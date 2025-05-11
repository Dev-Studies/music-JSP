<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userId = (String) session.getAttribute("userId");
    String nickname = (String) session.getAttribute("nickname");
    String playlistName = request.getParameter("name");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Playlist</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/style2.css">
    <link rel="stylesheet" href="/static/utility.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        #playlistSearch {
            margin-top: 20px;
            padding: 10px;
            width: 80%;
            background-color: #1e1e1e;
            color: white;
            border: 1px solid #444;
            border-radius: 6px;
        }

        #searchResults {
            margin-top: 20px;
            list-style: none;
            padding: 0;
        }

        #searchResults li {
            background: #2c2c2c;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
            color: white;
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>
<body>

<div class="container flex bg-black">
    <%@ include file="sidebar.jsp" %>

    <div class="right bg-grey rounded" style="padding: 40px; overflow-y: auto;">
        <!-- 상단 헤더 -->
        <div class="playlist-header" style="display: flex; align-items: flex-end; gap: 30px; padding: 40px 0; border-bottom: 1px solid #333;">
            <div class="playlist-cover" style="width: 200px; height: 200px; background-color: #222; display: flex; justify-content: center; align-items: center;">
                <i class="fa-solid fa-music" style="font-size: 48px; color: white;"></i>
            </div>
            <div>
                <h1 style="font-size: 40px; margin: 10px 0; color: white;"><%= playlistName %></h1>
            </div>
        </div>

        <!-- 재생 버튼 -->
        <div style="display: flex; gap: 20px; align-items: center; margin-top: 20px;">
            <button onclick="playUserPlaylist('<%= playlistName %>')" style="background: #1db954; color: white; padding: 10px 20px; border: none; border-radius: 20px; font-weight: bold; cursor: pointer;">
                ▶ 재생
            </button>
        </div>

        <!-- 현재 플레이리스트 곡 목록 -->
        <div style="margin-top: 50px;">
            <h3 style="color:white;">◆ 곡 목록</h3>
            <ul id="playlistSongList" style="margin-top: 10px; list-style: none; padding: 0;"></ul>
        </div>

        <!-- 검색 영역 -->
        <div style="margin-top: 40px;">
            <h3 style="color: white;">플레이리스트에 추가할 곡을 찾아보세요</h3>
            <input id="playlistSearch" type="text" placeholder="곡 검색하기"
                   style="margin-top: 15px; padding: 12px; width: 100%; background-color: #1e1e1e; color: white; border: 1px solid #444; border-radius: 6px;" />
            <ul id="searchResults" style="margin-top: 20px; list-style: none; padding: 0;"></ul>
        </div>

        <%@ include file="playbar.jsp" %>
    </div>
</div>

<!-- 공유된 script.js -->
<script src="/static/script.js"></script>

<!-- 페이지 전용 JS -->
<script>
    const playlistName = "<%= playlistName %>";
    sessionStorage.setItem("userId", "<%= userId %>");

    // 전역에 등록 (검색결과 ➕ 버튼에서 호출됨)
    window.addToUserPlaylist = function (song) {
        const userId = sessionStorage.getItem("userId");
        const playlistKey = `myPlaylist_${userId}`;
        let playlists = JSON.parse(localStorage.getItem(playlistKey) || "{}");

        if (!playlists[playlistName]) playlists[playlistName] = [];
        playlists[playlistName].push(song);
        localStorage.setItem(playlistKey, JSON.stringify(playlists));

        alert("추가 완료!");
        renderSidebarPlaylists();
        renderPlaylistSongs();
    };

    document.addEventListener("DOMContentLoaded", () => {
        const searchInput = document.getElementById("playlistSearch");
        const resultBox = document.getElementById("searchResults");

        if (!searchInput || !resultBox) {
            console.warn("검색창 또는 결과 영역 없음");
            return;
        }

        fetch("/static/songs/songInfo.json")
            .then(res => res.json())
            .then(data => {
                allSongs = data.cards.flatMap(card => card.songs);

                searchInput.addEventListener("input", () => {
                    const keyword = searchInput.value.toLowerCase();
                    const results = allSongs.filter(song => {
                        const fileName = decodeURIComponent(song.split("/").pop());
                        return fileName.toLowerCase().includes(keyword);
                    });

                    resultBox.innerHTML = results.map(song => {
                        const fileName = decodeURIComponent(song.split("/").pop());
                        return (
                            '<li>' +
                            '<span>' + fileName + '</span>' +
                            '<button onclick="addToUserPlaylist(\'' + song + '\')">➕</button>' +
                            '</li>'
                        );
                    }).join("");
                });
            });

        renderSidebarPlaylists();
        renderPlaylistSongs();
        setTimeout(setEventListeners, 100);
    });
</script>

</body>
</html>
