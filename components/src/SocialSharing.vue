<template>
  <ul
    class="clspt:social-sharing el:m-list el:m-list--hrz"
    :class="rootClasses"
  >
    <li v-if="callOut" class="callout" :class="callOutClasses">
      {{ callOut }}
    </li>
    <li class="cr-p" :class="iconClasses">
      <network network="linkedin">
        <icon
          name="linkedin-circle"
          width="1.25em"
          height="1.25em"
          class="fi-linkedin"
        ></icon>
      </network>
    </li>
    <li class="mL8 cr-p" :class="iconClasses">
      <network network="twitter">
        <icon
          name="twitter-circle"
          width="1.25em"
          height="1.25em"
          class="fi-twitter"
        ></icon>
      </network>
    </li>
    <li class="mL8 cr-p" :class="iconClasses">
      <network network="facebook">
        <icon
          name="facebook-circle"
          width="1.25em"
          height="1.25em"
          class="fi-facebook"
        ></icon>
      </network>
    </li>
    <li class="mL8 cr-p" :class="iconClasses">
      <network network="reddit">
        <icon
          name="reddit-circle"
          width="1.25em"
          height="1.25em"
          class="fi-reddit"
        ></icon>
      </network>
    </li>
  </ul>
</template>

<script>
  import Icon from "./Icon.vue";
  import VueSocialSharing from "vue-social-sharing";

  const componentDefinition = Object.assign({}, VueSocialSharing);

  componentDefinition.components.icon = Icon;
  componentDefinition.props.callOut = { type: String, default: null };
  componentDefinition.props.rootClasses = {
    type: Array,
    default() {
      return [];
    }
  };
  componentDefinition.props.callOutClasses = {
    type: Array,
    default() {
      return [];
    }
  };
  componentDefinition.props.iconClasses = {
    type: Array,
    default() {
      return [];
    }
  };

  export default componentDefinition;
</script>
