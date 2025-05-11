<%--playbar.jsp--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="playbar">
    <div class="seekbar">
        <div class="circle"></div>
    </div>
    <div class="abovebar">
        <div class="songinfo"></div>
        <div class="songbuttons">
            <img width="35" id="previous" src="static/img/prevsong.svg" alt="">
            <img width="35" id="play" src="static/img/play.svg" alt="">
            <img width="35" id="next" src="static/img/nextsong.svg" alt="">
        </div>
        <div class="timevol">
            <div class="songtime"></div>
            <div class="volume">
                <img width="25" src="static/img/volume.svg" alt="">
                <div class="range">
                    <input type="range" min="0" max="100" />
                </div>
            </div>
        </div>
    </div>
</div>

<script>

    const playBtn = document.getElementById("play");
    console.log("playBtn loaded?", playBtn); // null이면 아직 로딩 안 됨

</script>