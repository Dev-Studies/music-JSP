<!-- sidebar.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<div class="left">
    <div class="close">
        <img width="30" class="invert" src="static/img/close.svg" alt="">
    </div>
    <div class="home bg-grey rounded m-1 p-1">
        <div class="logo"><img width="110" class="invert" src="static/img/logo.svg" alt=""></div>
        <ul>
            <li><img class="invert" src="static/img/home.svg" alt="home"><a href="index.jsp" style="text-decoration: none; color: white">Home</a></li>
        </ul>
    </div>

    <div class="library bg-grey rounded m-1 p-1">
        <div class="heading">
            <img class="invert" src="static/img/playlist.svg" alt="">
            <h2>Your Library</h2>
            <button onclick="createNewPlaylist()" style="background:white;color:black;margin-top:10px;padding:6px 12px;border:none;border-radius:6px;">
                새 플레이리스트 추가
            </button>
        </div>
        <div class="songList">
            <ul></ul>
        </div>
    </div>
</div>