<template>
  <span>
    <lazy-hydrate ssr-only>
      <T :k="k" :options="options" />
    </lazy-hydrate>
  </span>
</template>

<script>
  import LazyHydrate from "~~lazy-hydration";

  export default {
    props: {
      k: {
        type: String,
        required: true
      },
      options: {
        type: Object,
        default() {
          return {};
        }
      }
    },
    components: {
      LazyHydrate,
      T: () => import("./T.vue")
    }
  };
</script>
