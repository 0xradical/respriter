<template>
  <div v-if='course.description' class='el:amx-Bot_gray el:amx-Bob_gray' :class='rootClasses'>
    <div class='clspt:course-description' @click.prevent.stop="toggle">
      <div class='el:amx-D(f) el:amx-FxJc(sb)'>
        <a class='el:amx-C_blue'>{{ toggled ? $t('dictionary.description.hide') : $t('dictionary.description.show') }}</a>
        <div>
          <icon width='1rem' height='1rem' :transform='`rotate(${toggled ? 180 : 0}deg)`' name='arrow-down'></icon>
        </div>
      </div>
      <transition name="fade">
        <div class='el:amx-Pt(0.5em) clspt:course-description__content' v-show='toggled' v-html='purifiedDescription'></div>
      </transition>
    </div>
  </div>
</template>

<script>
import Icon from './Icon.vue';

export default {
  props: {
    course: {
      type: Object,
      required: true
    },
    rootClasses: {
      type: Array,
      default() {
        return [];
      }
    }
  },
  data() {
    return {
      toggled: false
    }
  },
  computed: {
    purifiedDescription() {
      const html = this.$marked(this.course.description);
      const purified = this.$dompurify.sanitize(html, {
        ALLOWED_TAGS: [
          'h1','h2','h3','h4','h4',
          'p','div','table','thead',
          'tbody','tr','td','ul','li',
          'ol','br','hr','em','strong',
          'b','i','u','span','small'
        ]
      });

      return purified;
    }
  },
  methods: {
    toggle() {
      this.toggled = !this.toggled;
    },
  },
  components: {
    icon: Icon
  }
}
</script>

<style lang="scss" scoped>
.clspt\:course-description {
  cursor: pointer;
  position: relative;

  &__content {
    /deep/ h1, /deep/ h2, /deep/ h3, /deep/ h4, /deep/ h5 {
      font-size: 1.25em;
    }
    /deep/ p, /deep/ ul, /deep/ ol, /deep/ div, /deep/ table {
      font-size: 1em;
    }
  }
}

.fade-enter-active, .fade-leave-active {
  transition: all 5s;
}
.fade-enter {
  position: absolute;
  visibility: hidden;
  display: block;
  height: auto;
}

.fade-leave-to {
  position: relative;
  visibility: visible;
  display: none;
  height: 0;
}
</style>


