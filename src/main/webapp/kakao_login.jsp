<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*, java.io.*, org.json.*" %>


<%
    String code = request.getParameter("code");
    if (code == null) {
        out.println("인가 코드가 없습니다.");
        return;
    }

    // 1. 액세스 토큰 요청
    final String restApiKey = "************************"; // 카카오 REST API 키
    String redirectUri = "http://localhost:8080/kakao_login.jsp";

    URL url = new URL("https://kauth.kakao.com/oauth/token");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("POST");
    conn.setDoOutput(true);

    String params = "grant_type=authorization_code"
            + "&client_id=" + restApiKey
            + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8")
            + "&code=" + code;

    OutputStream os = conn.getOutputStream();
    os.write(params.getBytes());
    os.flush();
    os.close();

    BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    String result = "", line;
    while ((line = br.readLine()) != null) {
        result += line;
    }
    br.close();

    JSONObject json = new JSONObject(result);
    String accessToken = json.getString("access_token");

    // 2. 사용자 정보 요청
    URL infoUrl = new URL("https://kapi.kakao.com/v2/user/me?property_keys=[\"kakao_account.profile\"]");
    HttpURLConnection infoConn = (HttpURLConnection) infoUrl.openConnection();
    infoConn.setRequestMethod("GET");
    infoConn.setRequestProperty("Authorization", "Bearer " + accessToken);
    infoConn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

    BufferedReader infoBr = new BufferedReader(new InputStreamReader(infoConn.getInputStream(), "UTF-8"));
    String userInfo = "", infoLine;
    while ((infoLine = infoBr.readLine()) != null) {
        userInfo += infoLine;
    }
    infoBr.close();

    JSONObject userJson = new JSONObject(userInfo);
    String kakaoId = userJson.get("id").toString();
    JSONObject kaccount = userJson.getJSONObject("kakao_account");
    JSONObject profile = kaccount.getJSONObject("profile");
    String nickname = profile.getString("nickname");

    // 3. 세션에 사용자 저장
    session.setAttribute("userId", "kakao_" + kakaoId);
    session.setAttribute("nickname", nickname);

    response.sendRedirect("index.jsp");
%>