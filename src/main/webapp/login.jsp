<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    final String kakaoKey = "*******************************";
    String method = request.getMethod();
    if ("POST".equals(method)) {
        String id = request.getParameter("id");
        String password = request.getParameter("password");
        String saveId = request.getParameter("saveId");

        java.util.Map<String, String> userMap = (java.util.Map<String, String>) application.getAttribute("userMap");
        if (userMap != null && userMap.containsKey(id) && userMap.get(id).equals(password)) {
            session.setAttribute("userId", id);

            if (saveId != null) {
                Cookie c = new Cookie("savedId", id);
                c.setMaxAge(60 * 60 * 24 * 30); // 30일
                response.addCookie(c);
            } else {
                Cookie c = new Cookie("savedId", "");
                c.setMaxAge(0);
                response.addCookie(c);
            }

            response.sendRedirect("index.jsp");
            return;
        } else {
            request.setAttribute("msg", "아이디 또는 비밀번호가 잘못되었습니다.");
        }
    }

    String savedId = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("savedId".equals(c.getName())) {
                savedId = c.getValue();
                break;
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/style2.css">


</head>
<body>

<div class="form-container">
    <h2>로그인</h2>
<form method="post">
    <input type="text" name="id" placeholder="아이디" value="<%= savedId %>" required><br>
    <input type="password" name="password" placeholder="비밀번호" required><br>
    <label><input type="checkbox" name="saveId" <%= savedId.isEmpty() ? "" : "checked" %>> 아이디 저장</label><br>
    <input type="submit" value="로그인">
</form>
<% if (request.getAttribute("msg") != null) { %>
<p style="color:red;"><%= request.getAttribute("msg") %></p>
<% } %>
<a href="register.jsp">회원가입</a>
<br><a href="https://kauth.kakao.com/oauth/authorize?client_id=<%= kakaoKey %>&redirect_uri=http://localhost:8080/kakao_login.jsp&response_type=code">
    <img src="static/img/kakao_login_medium_narrow.png" alt="카카오 로그인" />
</a>
</div>
</body>
</html>