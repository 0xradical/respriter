<template>
  <div
    class="el:m-share"
    :class="[
      open && 'el:m-share--open',
      left && 'el:m-share--left',
      ...rootClasses
    ]"
  >
    <div class="el:m-share__ctl" @click="open = !open">
      <span
        v-if="callOut"
        class="el:m-share__ctl-callout"
        :data-callout="callOut"
      ></span>
    </div>
    <div class="el:m-share__pnl">
      <div class="el:m-share__pnl-opts">
        <ul class="el:m-share__pnl-opts-sns">
          <network
            network="linkedin"
            class="el:m-share__pnl-opts-sns--linkedin"
          />
          <network
            network="twitter"
            class="el:m-share__pnl-opts-sns--twitter"
          />
          <network
            network="facebook"
            class="el:m-share__pnl-opts-sns--facebook"
          />
        </ul>
        <div
          class="el:m-share__pnl-opts-ln"
          v-clipboard:copy="url"
          v-clipboard:success="onCopied"
        >
          <a
            class="el:m-share__pnl-opts-ln-txt"
            :data-txt="copied ? copiedText : linkText"
          ></a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import Icon from "./Icon.vue";
  import VueSocialSharing from "vue-social-sharing";

  const componentDefinition = Object.assign({}, VueSocialSharing);

  componentDefinition.components.icon = Icon;
  componentDefinition.props = {
    ...componentDefinition.props,
    networkTag: {
      type: String,
      default: "li"
    },
    callOut: {
      type: String,
      default: undefined
    },
    linkText: {
      type: String,
      default: "Copy link"
    },
    copiedText: {
      type: String,
      default: "Copied!"
    },
    rootClasses: {
      type: Array,
      default() {
        return [];
      }
    },
    left: {
      type: Boolean,
      default: false
    }
  };

  const dataFn = componentDefinition.data;
  componentDefinition.data = function () {
    return {
      ...dataFn(),
      open: false,
      copied: false
    };
  };
  componentDefinition.methods.onCopied = function () {
    this.copied = true;
    setTimeout(() => (this.copied = !this.copied), 5000);
  };

  export default componentDefinition;
</script>
