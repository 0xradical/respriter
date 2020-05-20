<template>
  <div class="el:o-dropdown">
    <a href="javascript:void(0)" class="el:o-dropdown__action">
      <slot name="action"></slot>
    </a>
    <ul
      class="el:o-dropdown__menu el:amx-Pb(-1.25em) el:o-dropdown__menu--dark el:o-dropdown__menu--right"
    >
      <slot name="menu"></slot>
    </ul>
  </div>
</template>

<script>
export default {
  data() {
    return {};
  }
};
</script>
