<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userId = (String) session.getAttribute("userId");
    String nickname = (String) session.getAttribute("nickname");
%>

<script>
    const isLoggedIn = <%= (userId != null) ? "true" : "false" %>;

    function goToPlaylistPage() {
        if (!isLoggedIn) {
            alert("플레이리스트 기능은 로그인 후 이용 가능합니다.");
            return;
        }
        window.location.href = "playlist.jsp";
    }
    sessionStorage.setItem("userId", "<%= userId %>");
</script>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/style2.css">
    <link rel="stylesheet" href="/static/utility.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Music Web Player</title>

    <script>
        sessionStorage.setItem("userId", "<%= userId %>");
    </script>
</head>

<body>
<div class="container flex bg-black">

    <%@ include file="sidebar.jsp" %>


    <div class="right bg-grey rounded">
        <div class="header">
            <div class="nav">
                <div class="hamburgerContainer">

                    <img width="40" class="invert hamburger" src="static/img/hamburger.svg" alt="">

                </div>
            </div>
            <div class="buttons">
                <% if (userId != null) { %>
                <span><%= nickname != null ? nickname : userId %> 님 안녕하세요!</span>
                <form action="logout.jsp" method="post" style="display:inline;">
                    <a href="logout.jsp"><button class="logoutbtn">로그아웃</button></a>
                </form>
                <% } else { %>
                <a href="register.jsp"><button class="signupbtn">회원가입</button></a>
                <a href="login.jsp"><button class="loginbtn">로그인</button></a>
                <% } %>
            </div>
        </div>
        <div class="spotifyPlaylists">
            <h1>추천 Playlists</h1>
            <div class="cardContainer">  </div>

            <div class="allTracks">
                <h2>All Songs</h2>
                <div style="margin-top: 20px;">
                    <input id="searchBox" placeholder="전체 곡 검색" />
                </div>

                <ul class="allSongList"></ul>
            </div>


            <%@ include file="playbar.jsp" %>
        </div>
    </div>
</div>
<script src="static/script.js"></script>
</body>

</html>