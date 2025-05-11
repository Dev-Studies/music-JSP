console.log('Lets write JavaScript');

const userId = sessionStorage.getItem("userId"); // index.jsp에 JSP에서 JS로 전달
const playlistKey = `myPlaylist_${userId}`;


let nowPlaylist = [];
let currentSongIndex = 0;
let allSongs = [];

window.audioPlayer = window.audioPlayer || new Audio();
const currentSong = window.audioPlayer;


function playUserPlaylist(name) {
    const playlists = JSON.parse(localStorage.getItem(playlistKey) || "{}");
    nowPlaylist = playlists[name];
    currentSongIndex = 0;
    playMusic(nowPlaylist[0]);
}

function secondsToMinutesSeconds(seconds) {
    if (isNaN(seconds) || seconds < 0) return "00:00";
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = Math.floor(seconds % 60);
    return `${String(minutes).padStart(2, '0')}:${String(remainingSeconds).padStart(2, '0')}`;
}

async function displayAlbums() {

    allSongs = []; // 초기화
    let res = await fetch('/static/songs/songInfo.json');
    let data = await res.json();

    let cardContainer = document.querySelector(".cardContainer");
    if (!cardContainer) return; // 📌 playlist.jsp에서는 존재하지 않음

    cardContainer.innerHTML = "";

    data.cards.forEach((card, index) => {
        let div = document.createElement("div");
        div.className = "card";
        div.setAttribute("data-index", index);
        div.innerHTML = `
            <div class="play">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                    xmlns="http://www.w3.org/2000/svg">
                    <path d="M5 20V4L19 12L5 20Z" stroke="#141B34" fill="#000" stroke-width="1.5"
                        stroke-linejoin="round" />
                </svg>
            </div>
            <img src="${card.cover}" alt="">
            <h2>${card.title}</h2>
            <p>${card.description}</p>
            <button class="addToPlaylist" 
                style="position: absolute; top: 10px; right: 10px; background: transparent; border: none; font-size: 18px; cursor: pointer;"
                data-songs='${JSON.stringify(card.songs)}' data-title="${card.title}">
                <i class="fa-solid fa-plus" style="color:white;"></i>
            </button>
        `;
        cardContainer.appendChild(div);

        // play button 클릭하면 재생 목록 설정 및 첫 곡 재생
        div.querySelector(".play").addEventListener("click", (e) => {
            e.stopPropagation(); // 카드 클릭 이벤트 차단
            nowPlaylist = card.songs;
            currentSongIndex = 0;
            playMusic(nowPlaylist[0]);
        });

        // ➕ 플레이리스트 추가 버튼
        div.querySelector(".addToPlaylist").addEventListener("click", (e) => {
            e.stopPropagation();
            const songs = JSON.parse(e.currentTarget.dataset.songs);
            const title = e.currentTarget.dataset.title;
            let playlists = JSON.parse(localStorage.getItem(playlistKey) || "{}");
            playlists[title] = songs;
            localStorage.setItem(playlistKey, JSON.stringify(playlists));
            renderSidebarPlaylists();
        });



        allSongs.push(...card.songs);
    });

}

function playMusic(track, pause = false) {
    console.log("Trying to play:", track);  // ✅ 확인 로그
    currentSong.src = track;
    currentSong.load();
    if (!pause) {
        currentSong.play();
        const playBtn = document.getElementById("play");
        if (playBtn) playBtn.src = "static/img/pause.svg";
    } else {
        const playBtn = document.getElementById("play");
        if (playBtn) playBtn.src = "static/img/play.svg";
    }

    const songInfo = document.querySelector(".songinfo");
    const songTime = document.querySelector(".songtime");
    if (songInfo) songInfo.innerText = decodeURI(track.split("/").pop());
    if (songTime) songTime.innerText = "00:00 / 00:00";
}


function displayAllSongs() {
    let list = document.querySelector(".allSongList");
    if (!list) return;  // 🔧 playlist.jsp에는 해당 요소 없음

    list.innerHTML = "";
    allSongs.forEach(song => {
        const li = document.createElement("li");
        // 곡 제목 추출
        li.innerHTML = `
            ${decodeURI(song.split("/").pop())} 
            <button onclick="playMusic('${song}')">▶</button>
        `;
        list.appendChild(li);
    });
}

function createNewPlaylist() {
    const playlists = JSON.parse(localStorage.getItem(playlistKey) || "{}");
    let newName = "플레이리스트";
    let count = 1;
    while (playlists[newName]) {
        newName = `플레이리스트${count++}`;
    }
    playlists[newName] = [];
    localStorage.setItem(playlistKey, JSON.stringify(playlists));
    window.location.href = `playlist.jsp?name=${encodeURIComponent(newName)}`;
}

function renderSidebarPlaylists() {
    const playlists = JSON.parse(localStorage.getItem(playlistKey) || "{}");
    const sidebarList = document.querySelector('.songList ul');

    sidebarList.innerHTML = Object.entries(playlists).map(([name, songs]) => `
        <li class="flex" style="cursor:pointer;" onclick="window.location.href='playlist.jsp?name=${encodeURIComponent(name)}'">
            <div>🎵 ${name}</div>
            <small>(${songs.length}곡)</small>
        </li>
    `).join("");
}

function setEventListeners() {
    const playBtn = document.getElementById("play");
    const prevBtn = document.getElementById("previous");
    const nextBtn = document.getElementById("next");
    const seekbar = document.querySelector(".seekbar");
    const volumeSlider = document.querySelector(".range input");
    const volumeIcon = document.querySelector(".volume > img");
    const hamburger = document.querySelector(".hamburger");
    const closeBtn = document.querySelector(".close");
    const searchInput = document.getElementById("searchBox");
    const logoutBtn = document.querySelector(".logoutbtn");

    if (playBtn) {
        playBtn.addEventListener("click", () => {
            if (currentSong.paused) {
                currentSong.play();
                playBtn.src = "static/img/pause.svg";
            } else {
                currentSong.pause();
                playBtn.src = "static/img/play.svg";
            }
        });
    }

    if (prevBtn) {
        prevBtn.addEventListener("click", () => {
            if (currentSongIndex > 0) {
                currentSongIndex--;
                playMusic(nowPlaylist[currentSongIndex]);
            }
        });
    }

    if (nextBtn) {
        nextBtn.addEventListener("click", () => {
            if (currentSongIndex < nowPlaylist.length - 1) {
                currentSongIndex++;
                playMusic(nowPlaylist[currentSongIndex]);
            }
        });
    }

    if (seekbar) {
        seekbar.addEventListener("click", e => {
            const percent = e.offsetX / e.target.getBoundingClientRect().width;
            currentSong.currentTime = percent * currentSong.duration;
        });
    }

    if (volumeSlider) {
        volumeSlider.addEventListener("change", (e) => {
            currentSong.volume = parseInt(e.target.value) / 100;
            if (volumeIcon && currentSong.volume > 0) {
                volumeIcon.src = "static/img/volume.svg";
            }
        });
    }

    if (volumeIcon) {
        volumeIcon.addEventListener("click", e => {
            if (e.target.src.includes("volume.svg")) {
                currentSong.volume = 0;
                if (volumeSlider) volumeSlider.value = 0;
                e.target.src = "static/img/mute.svg";
            } else {
                currentSong.volume = 0.1;
                if (volumeSlider) volumeSlider.value = 10;
                e.target.src = "static/img/volume.svg";
            }
        });
    }

    currentSong.addEventListener("timeupdate", () => {
        const current = secondsToMinutesSeconds(currentSong.currentTime);
        const total = secondsToMinutesSeconds(currentSong.duration);
        const songTime = document.querySelector(".songtime");
        const circle = document.querySelector(".circle");

        if (songTime) songTime.innerText = `${current} / ${total}`;
        if (circle && currentSong.duration > 0) {
            circle.style.left = `${(currentSong.currentTime / currentSong.duration) * 100}%`;
        }
    });

    if (hamburger) {
        hamburger.addEventListener("click", () => {
            document.querySelector(".left").style.left = "0";
        });
    }

    if (closeBtn) {
        closeBtn.addEventListener("click", () => {
            document.querySelector(".left").style.left = "-120%";
        });
    }

    document.querySelectorAll(".addToPlaylist").forEach(btn => {
        btn.addEventListener("click", () => {
            const songs = JSON.parse(btn.dataset.songs);
            const title = btn.dataset.title;
            let playlists = JSON.parse(localStorage.getItem(playlistKey) || "{}");
            playlists[title] = songs;
            localStorage.setItem(playlistKey, JSON.stringify(playlists));
            renderSidebarPlaylists();
        });
    });

    if (searchInput) {
        searchInput.addEventListener("input", function () {
            const keyword = this.value.toLowerCase();
            const list = document.querySelector(".allSongList");
            if (!list) return;
            Array.from(list.children).forEach(li => {
                li.style.display = li.innerText.toLowerCase().includes(keyword) ? "block" : "none";
            });
        });
    }

    if (logoutBtn) {
        logoutBtn.addEventListener("click", () => {
            if (window.audioPlayer) {
                window.audioPlayer.pause();
                window.audioPlayer.src = "";
            }
            window.location.href = "logout.jsp";
        });
    }
}

function renderPlaylistSongs() {
    const playlistSongList = document.getElementById("playlistSongList");
    if (!playlistSongList) return;

    const playlists = JSON.parse(localStorage.getItem(playlistKey) || "{}");
    const songs = playlists[playlistName] || [];

    playlistSongList.innerHTML = songs.map(song => {
        if (!song) return "";
        const title = decodeURIComponent(song.split("/").pop());
        return (
            '<li style="color:white; padding: 10px; background: #2c2c2c; margin-bottom: 10px; border-radius: 6px;">' +
            title +
            '<button onclick="playMusic(\'' + song + '\')" style="margin-left: 10px;">▶</button>' +
            '</li>'
        );
    }).join("");
}


async function main() {
    await displayAlbums();
    await displayAllSongs();
    renderSidebarPlaylists();
    setEventListeners();
}

main();
