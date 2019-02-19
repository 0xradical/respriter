// Import Elements
import 'elements/build/dist/elements.bundle.css'
import 'elements/build/dist/elements.bundle.js'
import 'elements/build/icon-font.css'
import iconsLib from '!file-loader?name=[name]-[hash].[ext]!elements/build/dist/svgs/icons-lib'
import providersLib from '!file-loader?name=[name]-[hash].[ext]!elements/build/dist/svgs/providers-lib'

// Import single svgs
import '!file-loader?name=[name].[ext]!elements/build/dist/svgs/quero-logo'
import '!file-loader?name=[name].[ext]!elements/build/dist/svgs/no-video'

import '../js/video_player'

// Import Tippy
import tippy from 'tippy.js'
import 'tippy.js/dist/tippy.css'

tippy.setDefaults({
  animation: 'fade',
  theme: 'quero',
  arrow: true
});

tippy();

document.addEventListener('DOMContentLoaded', () => {
  //tippy();
});

// Import Blocks
import 'blocks/build/dist/blocks.all.js'


window.iconsLibPath = iconsLib
window.providersLibPath = providersLib