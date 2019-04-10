// Import Elements
import 'elements/build/dist/elements.bundle.css'
import 'elements/build/dist/elements.bundle.js'
import 'elements/build/icon-font.css'
import iconsLibPath from '!file-loader?name=[name]-[hash].[ext]!elements/build/dist/svgs/icons-lib'
import providersLibPath from '!file-loader?name=[name]-[hash].[ext]!elements/build/dist/svgs/providers-lib'

// Import single svgs
import '!file-loader?name=[name].[ext]!elements/build/dist/svgs/logo'
import '!file-loader?name=[name].[ext]!elements/build/dist/svgs/logo_negative'
import '!file-loader?name=[name].[ext]!elements/build/dist/svgs/logo_symbol'
import '!file-loader?name=[name].[ext]!elements/build/dist/svgs/logo_symbol-negative'
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

// Avoid strong CORS rules
window.iconsLibPath = iconsLibPath.replace(/.*\/([-_\w]*\/[-_\w]*\.svg)$/, "$1")
window.providersLibPath = providersLibPath.replace(/.*\/([-_\w]*\/[-_\w]*\.svg)$/, "$1")

// Import Blocks
import 'blocks/build/dist/blocks.all.js'
