import iframeJST from '!ejs-loader!./iframe.jst.ejs'
import videoJST from '!ejs-loader!./video.jst.ejs'

document.addEventListener('DOMContentLoaded', () => {
  const videoPlayers = document.querySelectorAll('[data-embedded-video]')
  videoPlayers.forEach(function (videoPlayer) {
    videoPlayer.addEventListener('click', function (e) {
      console.log(videoPlayer);
      fetch(videoPlayer.getAttribute('data-embedded-video')).then(function (response) {
        response.json().then(function (json) {
          console.log(json)
          videoPlayer.innerHTML = json.embed ? iframeJST(json) : videoJST(json)
        })
      });
    })
  })
});
