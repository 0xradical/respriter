<template>
  <div>
    <link
      rel="stylesheet"
      media="screen"
      :href="`${$envs.elementsHost}/${$envs.elementsVersion}/bundle.css`"
    />
    <slot></slot>
  </div>
</template>

<script>
export default {};
</script>
