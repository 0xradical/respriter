<template>
  <div
    class="clspt:course-description__content"
    :class="rootClasses"
    v-html="purifiedDescription || 'N/A'"
  ></div>
</template>

<script>
import _ from "~~lodash";
import marked from "~~marked";
import DOMPurify from "~~dompurify";

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
      const html = marked(_.unescape(this.course.description));
      const purified = DOMPurify.sanitize(html, {
        ALLOWED_TAGS: [
          "h1",
          "h2",
          "h3",
          "h4",
          "h4",
          "p",
          "div",
          "table",
          "thead",
          "tbody",
          "tr",
          "td",
          "ul",
          "li",
          "ol",
          "br",
          "hr",
          "em",
          "strong",
          "b",
          "i",
          "u",
          "span",
          "small"
        ]
      });

      return purified;
    }
  }
};
</script>

<style lang="scss">
.clspt\:course-description {
  cursor: pointer;
  position: relative;

  &__content {
    ::v-deep h1,
    ::v-deep h2,
    ::v-deep h3,
    ::v-deep h4,
    ::v-deep h5 {
      font-size: 1.25em;
    }
    ::v-deep p,
    ::v-deep ul,
    ::v-deep ol,
    ::v-deep div,
    ::v-deep table {
      font-size: 1em;
    }
    ::v-deep p {
      margin: 0;
      line-height: 1.5;
      word-break: break-word;
      width: 100%;
    }
  }
}
</style>
