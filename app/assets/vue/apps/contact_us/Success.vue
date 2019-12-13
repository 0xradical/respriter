<template>
  <div class='clspt:contact-us__successful container'>
    <div class='row'>
      <div class='col el:amx-Ta(c)'>
        <span class='el:amx-C_gray5 el:amx-Fs(1.5em) el:amx-Fs(2em)@>lg el:amx-Fw(b) el:amx-Lh(1)'>
          {{ $t('contact_us.new.successful.title') }}
        </span>
      </div>
    </div>
    <div class='row el:amx-Mt(0.5em)'>
      <div class='offset-lg-4 col-lg-4 el:amx-Ta(c)'>
        <span class='el:amx-C_gray5 el:amx-Fs(1em) el:amx-Fs(1.25em)@>lg el:amx-Lh(2)'>
          {{ $t('contact_us.new.successful.subtitle') }}
        </span>
      </div>
    </div>
    <div class="row el:amx-Mt(2em)">
      <div class='offset-lg-3 col-lg-3'>
        <a @click.prevent='$emit("goback")' class='btn btn--block btn--medium btn--blue-border'>
          {{ $t('contact_us.new.successful.action.another_message') }}
        </a>
      </div>
      <div class='col-lg-3 el:amx-Mt(1em)@<sm'>
        <a href='/' class='btn btn--block btn--medium btn--blue-flat'>
          {{ $t('contact_us.new.successful.action.homepage') }}
        </a>
      </div>
    </div>
  </div>
</template>

<script>
export default {

}
</script>

<style lang="scss" scoped>
@import "~@classpert/elements/src/scss/config/variables/breakpoints";

.clspt\:contact-us__successful {
  margin-top: 7.5em;
  margin-bottom: 8.75em;

  @media (--lg-min) {
    margin-top: 10em;
    margin-bottom: 10em;
  }
}
</style>
