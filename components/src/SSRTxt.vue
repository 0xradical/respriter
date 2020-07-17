<template>
  <span>
    <lazy-hydrate ssr-only>
      <Txt><slot></slot></Txt>
    </lazy-hydrate>
  </span>
</template>

<script>
  import LazyHydrate from "~~lazy-hydration";

  export default {
    components: {
      LazyHydrate,
      Txt: () => import("./Txt.vue")
    }
  };
</script>
