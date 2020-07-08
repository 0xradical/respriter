<template>
  <div
    class="provider-navcard el:amx-Bc_su"
    :style="{ width: '255px', height: height }"
  >
    <a class="provider-navcard__frame el:amx-D(f)" :href="link" style="">
      <div class="el:m-attribute">
        <svg
          class="provider-navcard__icon el:m-attribute__icon el:m-attribute__icon--bordered el:amx-Mr(1em)"
        >
          <use :xlink:href="`#providers-${slug}`" />
        </svg>
      </div>
      <div
        class="provider-navcard__link el:amx-D(f) el:amx-Mt(2em) el:amx-FxAi(c)"
      >
        <span class="provider-navcard__link-text el:amx-Fw(b)">{{
          linkText
        }}</span>
        <svg class="provider-navcard__link-icon">
          <use xlink:href="#icons-arrow-down" class="el:amx-C_pr" />
        </svg>
      </div>
    </a>
  </div>
</template>

<script>
  export default {
    props: {
      slug: {
        type: String,
        required: true
      },
      height: {
        type: String,
        default: "350px"
      },
      link: {
        type: String,
        required: true
      },
      linkText: {
        type: String,
        required: true
      }
    }
  };
</script>

<style lang="scss">
  .provider-navcard {
    &__frame {
      height: 100%;
      flex-direction: column;
      justify-content: start;
      align-items: center;
      position: relative;
      top: 25%;
    }

    &__icon {
      flex: 0 0 4rem;
      width: 4rem;
      height: 4rem;
    }

    &__link {
      font-size: 0.875rem;
      &-text {
        margin-right: 0.5rem;
      }
      &-icon {
        transform: rotate(-90deg);
        width: 1em;
        height: 1em;
      }
    }
  }
</style>
