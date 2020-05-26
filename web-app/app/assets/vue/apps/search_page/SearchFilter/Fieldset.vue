<template>
  <fieldset class="el:o-fieldset-frame">
    <div class="el:o-fieldset-frame__header">
      <slot name="title">
        <legend
          v-if="title"
          class="el:o-fieldset-frame__title"
          :class="{ 'el:o-fieldset-frame__title--stand-out': standOut }"
        >
          {{ title }}
        </legend>
      </slot>
      <slot name="subtitle">
        <template v-if="subtitle">
          <div class="subtitle__separator--begin">(</div>
          <div class="subtitle__body">{{ subtitle }}</div>
          <div class="subtitle__separator--end">)</div>
        </template>
      </slot>
      <slot name="action"></slot>
    </div>
    <slot></slot>
  </fieldset>
</template>

<script>
  export default {
    props: {
      title: {
        type: String
      },
      standOut: {
        type: Boolean,
        default: false
      },
      subtitle: {
        type: String
      }
    }
  };
</script>

<style lang="scss" scoped>
  .subtitle__separator--begin {
    margin-left: 0.5em;
    font-size: 0.75rem;
    padding-top: 3px;
  }
  .subtitle__body {
    min-width: 0;
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
    font-size: 0.75rem;
    padding-top: 3px;
  }
  .subtitle__separator--end {
    margin-right: 0.5em;
    font-size: 0.75rem;
    padding-top: 3px;
  }
</style>
