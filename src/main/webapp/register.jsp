<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String method = request.getMethod();
    if ("POST".equals(method)) {
        String id = request.getParameter("id");
        String password = request.getParameter("password");

        // 사용자 정보 저장
        java.util.Map<String, String> userMap = (java.util.Map<String, String>) application.getAttribute("userMap");
        if (userMap == null) {
            userMap = new java.util.HashMap<>();
        }

        if (!userMap.containsKey(id)) {
            userMap.put(id, password);
            application.setAttribute("userMap", userMap);
            response.sendRedirect("login.jsp"); // 성공 후 로그인 페이지로 이동
            return;
        } else {
            request.setAttribute("msg", "이미 존재하는 아이디입니다.");
        }
    }
%>


<html>
<head>
    <title>Register</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/style2.css">

    </style>
</head>

<body>


<div class="form-container">
    <h2>회원가입</h2>
<form method="post">
    <input type="text" name="id" placeholder="아이디" required><br>
    <input type="password" name="password" placeholder="비밀번호" required><br>
    <input type="submit" value="가입하기">
</form>
<% if (request.getAttribute("msg") != null) { %>
<p style="color:red;"><%= request.getAttribute("msg") %></p>
<% } %>
<a href="login.jsp">로그인하러 가기</a>

</div>
</body>
</html>
