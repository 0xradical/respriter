import iframeJST from '!ejs-loader!./iframe.jst.ejs'
import videoJST from '!ejs-loader!./video.jst.ejs'

window.initVideoPlayers = () => {
  const nodeList = document.querySelectorAll('[data-embedded-video]')
  nodeList.forEach(function (node) {
    node.addEventListener('click', function (e) {
      this.style = 'display:none'
      fetch(this.getAttribute('data-embedded-video')).then(function (response) {
        response.json().then(function (json) {
          document.querySelectorAll(node.getAttribute('data-embedded-video-target')).forEach(function (node) {
            if (json.mode == 'html5') {
              node.innerHTML = videoJST(json)
            } else {
              node.innerHTML = iframeJST(json)
            }
          })
        })
      });
    })
  })
}

document.addEventListener('DOMContentLoaded', () => {
  initVideoPlayers();
});
