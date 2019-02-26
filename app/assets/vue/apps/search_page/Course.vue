<template>
  <div :id='course.url_id' class='c-hcard'>

    <div class='c-hcard__content-slot'>
      <h6 class='mx-C(dark-gray)' style='margin-bottom:8px;'>
        <div class="logo" style="display:inline-block;width:24px;vertical-align:middle;box-sizing:border-box">
          <svg viewBox="0 0 100 100" style='margin:15%'>
            <use :xlink:href='logo'></use>
          </svg>
        </div>
        {{ course.provider_name }}
      </h6>
      <h3 :title='course.name' class='c-hcard__title'>
        {{ course.name }}
      </h3>
      <ul class='c-hcard__meta' style='display:inline-block;vertical-align:middle'>
        <li>
          <span class='c-label'>
            <svg class='c-label__icon'>
              <use :xlink:href="audioIcon" />
            </svg>
            <span class='c-label__text c-label__text--shrink-25% c-label__text--uppercase'>{{ course.audio.join(', ') }}</span>
          </span>
        </li>
        <li>
          <span class='c-label'>
            <svg class='c-label__icon'>
              <use :xlink:href='subtitleIcon'></use>
            </svg>
            <span class='c-label__text c-label__text--shrink-25% c-label__text--uppercase'>{{ course.subtitles.join(', ') }}</span>
          </span>
        </li>
      </ul>
    </div>

    <div class='c-hcard__price-slot'>
      <span v-if='price > 0' class='c-hcard__price'> {{ price | currency }} </span>
      <span v-if='price == 0 || course.price == null' class='c-tag c-tag--blue'> {{ $t('dictionary.free') }} </span>
      <a rel='nofollow' class='mx-D(n)@tablet mx-D(n)@tv mx-D(n)@desktop btn btn--blue-border btn--tiny btn--rounded' target='_blank' :href='course.gateway_path'>
        {{ $t('dictionary.go_to_course') }}
      </a>
    </div>

    <div class='mx-D(n)@phone c-hcard__btn-slot'>
      <a data-gtm-event='goToCourseEvent' style='margin-bottom:10px' v-if='course.video_url' class='btn btn--block btn--tiny btn--rounded btn--dark-gray-flat' 
        @click="$modal.show('course-modal', { course: course })" href='javascript:void(0)'>
        <span class='c-label'>
          <svg class='c-label__icon'>
            <use :xlink:href='playIcon' />
          </svg>
          <span class='c-label__text'>&nbsp; Watch preview</span>
        </span>
      </a>
      <a rel='nofollow' class='mx-D(n)@phone btn btn--green-flat btn--tiny btn--rounded btn--block' target='_blank' :href='course.gateway_path'>
        {{$t('dictionary.go_to_course') }}</a>
    </div>

  </div>
</template>

<script>
import { slugify } from 'transliteration';
export default {

  props: {
    course: {
      type: Object,
      required: true
    }
  },

  data () {
    return {}
  },

  computed: {

    playIcon () {
      return window.iconsLibPath + '#play'
    },

    audioIcon () {
      return window.iconsLibPath + '#audio'
    },

    subtitleIcon () {
      return window.iconsLibPath + '#subtitle'
    },

    logo () {
      return `${window.providersLibPath}#${slugify(this.course.provider_name)}`
    },

    price () {
      return parseFloat(this.course.price)
    }

  }
}
</script>
