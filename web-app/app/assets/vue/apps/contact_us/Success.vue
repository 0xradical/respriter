<template>
  <div class="clspt:contact-us__successful container">
    <div class="row">
      <div class="col ta-c">
        <span
          class="c-fg fs24 fs32@>lg fw-b lh1"
        >
          {{ $t("contact_us.new.successful.title") }}
        </span>
      </div>
    </div>
    <div class="row mT8">
      <div class="offset-lg-4 col-lg-4 ta-c">
        <span
          class="c-fg fs16 fs20@>lg lh3"
        >
          {{ $t("contact_us.new.successful.subtitle") }}
        </span>
      </div>
    </div>
    <div class="row mT32">
      <div class="offset-lg-3 col-lg-3">
        <a
          @click.prevent="$emit('goback')"
          class="el:m-button el:m-button--block el:m-button--medium el:m-button--primary-border"
        >
          {{ $t("contact_us.new.successful.action.another_message") }}
        </a>
      </div>
      <div class="col-lg-3 mT16@<sm">
        <a
          href="/"
          class="el:m-button el:m-button--block el:m-button--medium el:m-button--primary-flat"
        >
          {{ $t("contact_us.new.successful.action.homepage") }}
        </a>
      </div>
    </div>
  </div>
</template>

<script>
  export default {};
</script>

<style lang="scss" scoped>
  @import "@classpert/elements/src/scss/config/variables/_breakpoints.scss";

  .clspt\:contact-us__successful {
    margin-top: 7.5em;
    margin-bottom: 8.75em;

    @media (--lg-min) {
      margin-top: 10em;
      margin-bottom: 10em;
    }
  }
</style>
