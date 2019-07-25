<template>
  <div class='clspt:course-description__content' :class='rootClasses' v-html='purifiedDescription'></div>
</template>

<script>
import marked from '../../js/marked';
import domPurify from '../../js/dompurify';

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
  computed: {
    purifiedDescription() {
      const html = marked(this.course.description);
      const purified = domPurify.sanitize(html, {
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
  }
}
</script>

<style lang="scss">
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
    /deep/ p {
      margin: 0;
      line-height: 1.5;
      word-break: break-word;
      width: 100%;
    }
  }
}
</style>


