<template>
  <ul class='clspt:social-sharing el:m-list el:m-list--hrz' :class='rootClasses'>
    <li v-if='callOut' class='callout' :class='callOutClasses'>{{ callOut }}</li>
    <li class='el:amx-Cur(p)' :class='iconClasses'>
      <network network="linkedin">
        <icon name='linkedin-circle' width='1.25em' height='1.25em' class='el:amx-Fi_linkedin'></icon>
      </network>
    </li>
    <li class='el:amx-Ml(0.5em) el:amx-Cur(p)' :class='iconClasses'>
      <network network="twitter">
        <icon name='twitter-circle' width='1.25em' height='1.25em' class='el:amx-Fi_twitter'></icon>
      </network>
    </li>
    <li class='el:amx-Ml(0.5em) el:amx-Cur(p)' :class='iconClasses'>
      <network network="facebook">
        <icon name='facebook-circle' width='1.25em' height='1.25em' class='el:amx-Fi_facebook'></icon>
      </network>
    </li>
    <li class='el:amx-Ml(0.5em) el:amx-Cur(p)' :class='iconClasses'>
      <network network="reddit">
        <icon name='reddit-circle' width='1.25em' height='1.25em' class='el:amx-Fi_reddit'></icon>
      </network>
    </li>
  </ul>
</template>

<script>
import Icon from './Icon.vue';
import VueSocialSharing from 'vue-social-sharing';

VueSocialSharing.components.icon = Icon;
VueSocialSharing.props.callOut = { type: String, default: null }
VueSocialSharing.props.rootClasses = { type: Array, default() { return []; } }
VueSocialSharing.props.callOutClasses = { type: Array, default() { return []; } }
VueSocialSharing.props.iconClasses = { type: Array, default() { return []; } }

export default VueSocialSharing;
</script>
