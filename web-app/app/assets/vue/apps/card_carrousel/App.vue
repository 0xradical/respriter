<template>
  <card-carrousel
    :component="component"
    :list="list"
    :property="property"
    :navigation="navigation"
    :height="height"
  />
</template>

<script>
  import CardCarrousel from "components/CardCarrousel.vue";

  export default {
    props: {
      component: {
        type: String,
        required: true
      },
      locale: {
        type: String,
        default: "en"
      },
      list: {
        type: Array,
        default() {
          return [];
        }
      },
      property: {
        type: String,
        required: true
      },
      height: {
        type: String,
        required: true
      },
      navigation: {
        type: Object,
        required: false,
        default() {
          return {};
        }
      }
    },
    created() {
      this.$i18n.locale = this.locale;
    },
    components: {
      CardCarrousel
    }
  };
</script>
