<template>
  <ul class='c-list c-list--unstyled c-list--inline' :class='rootClasses'>
    <li v-if='callOut' class='callout' :class='callOutClasses'>{{ callOut }}</li>
    <li class='el:amx-Ml(0.5em) el:amx-Cur(p)' :class='iconClasses'>
      <network network="linkedin">
        <icon name='linkedin_share' width='1.25em' height='1.25em'></icon>
      </network>
    </li>
    <li class='el:amx-Ml(0.5em) el:amx-Cur(p)' :class='iconClasses'>
      <network network="twitter">
        <icon name='twitter_share' width='1.25em' height='1.25em'></icon>
      </network>
    </li>
    <li class='el:amx-Ml(0.5em) el:amx-Cur(p)' :class='iconClasses'>
      <network network="facebook">
        <icon name='facebook_share' width='1.25em' height='1.25em'></icon>
      </network>
    </li>
    <li class='el:amx-Ml(0.5em) el:amx-Cur(p)' :class='iconClasses'>
      <network network="reddit">
        <icon name='reddit_share' width='1.25em' height='1.25em'></icon>
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

<style lang="scss" scoped>
li {
  height: 1.25em;
}

li.callout {
  margin: auto 0;
}
</style>
