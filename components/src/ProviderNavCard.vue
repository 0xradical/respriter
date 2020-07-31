<template>
  <div
    class="provider-navcard"
    :class="rootClasses"
    :style="{ width: '255px', height: height }"
  >
    <a class="provider-navcard__frame" :href="link" style="">
      <div class="el:m-attribute">
        <svg class="provider-navcard__icon el:m-attribute__icon">
          <use :xlink:href="`#providers-${slug}`" />
        </svg>
      </div>
      <div class="provider-navcard__link">
        <span class="provider-navcard__link-text">{{ linkText }}</span>
        <svg class="provider-navcard__link-icon">
          <use xlink:href="#icons-arrow-down" />
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
      },
      rootClasses: {
        type: Array,
        default() {
          return [];
        }
      }
    }
  };
</script>

<style lang="scss">
  .provider-navcard {
    font-size: 1rem;
    background-color: var(--surface);

    &__frame {
      display: flex;
      height: 100%;
      flex-direction: column;
      justify-content: flex-start;
      align-items: center;
      position: relative;
      top: 25%;
    }

    &__icon {
      flex: 0 0 4em;
      width: 4em;
      height: 4em;
      margin-right: 1em;
    }

    &__link {
      display: flex;
      align-items: center;
      font-size: 0.875em;
      margin-top: 2em;

      &-text {
        margin-right: 0.5em;
        font-weight: bold;
      }
      &-icon {
        transform: rotate(-90deg);
        color: var(--primary);
        width: 1em;
        height: 1em;
      }
    }
  }
</style>
