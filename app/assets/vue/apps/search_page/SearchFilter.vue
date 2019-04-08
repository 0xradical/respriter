<template>
  <form>

    <fieldset style='border:0;padding:0;margin:0'>
      <legend style='padding:10px 15px'>{{ $t("dictionary.price") }}</legend>
      <div class='mx-Bc(light-gray)' style='padding:15px;font-size:0.875rem'>
        <ul style='list-style:none;margin:0;padding:0;font-size:0.875rem'>
          <li class='filter' style='margin-bottom:10px'>
            {{ $t('dictionary.min') }}
              $<input v-model.lazy='priceModel.input.min' type='number' min='0' name='price' style='vertical-align:middle;margin:0;font-size:0.75rem;max-width:54px;'>
            {{ $t('dictionary.max') }} $
            <input v-model.lazy='priceModel.input.max' type='number' min='0' name='price' style='vertical-align:middle;margin:0;font-size:0.75rem;max-width:54px;'>
          </li>
          <li>
            <label>
              <input v-model='priceModel.ranges' :value="[0,0]" type='checkbox' name='price' style='vertical-align:middle;margin:0'>
              {{ $t('dictionary.only_free') }}
            </label>
          </li>
        </ul>
      </div>
    </fieldset>

    <fieldset style='border:0;padding:0;margin:0'>
      <legend style='padding:10px 15px'>{{$t("dictionary.audio")}}</legend>
      <div class='mx-Bc(light-gray)' style='padding:15px;font-size:0.75em'>
        <ul style='list-style:none;margin:0;padding:0'>
          <li v-for='audio in aggregations.audios.buckets'>
            <label>
              <input v-model='filter.audio' :value="audio.key" type='checkbox' name='audio' style='vertical-align:middle;margin:0'>
              {{ $t(`iso639_codes.${audio.key}`) }} ({{ audio.doc_count }})
            </label>
          </li>
        </ul>
      </div>
    </fieldset>

    <fieldset style='border:0;padding:0;margin:0'>
      <legend style='padding:10px 15px'>{{ $t("dictionary.subtitles") }}</legend>
      <div class='mx-Bc(light-gray)' style='padding:15px;font-size:0.75em'>
        <ul style='list-style:none;margin:0;padding:0'>
          <li v-for='subtitle in aggregations.subtitles.buckets'>
            <label style='vertical-align:top'>
              <input v-model='filter.subtitles' :value="subtitle.key" type='checkbox' name='subtitles' style='vertical-align:middle;margin:0'>
              {{ $t(`iso639_codes.${subtitle.key}`) }} ({{ subtitle.doc_count }})
            </label>
          </li>
        </ul>
      </div>
    </fieldset>

    <fieldset v-if='showCategoriesFilter' style='border:0;padding:0;margin:0'>
      <legend style='padding:10px 15px'>{{ $t("dictionary.categories") }}</legend>
      <div class='mx-Bc(light-gray)' style='padding:15px;font-size:0.75em'>
        <ul style='list-style:none;margin:0;padding:0'>
          <li v-for='category in aggregations.categories.buckets'>
            <label style='vertical-align:top'>
              <input v-model='filter.categories' :value="category.key" type='checkbox' name='categories' style='vertical-align:middle;margin:0'>
              {{ $t(`tags.${category.key}`) }} ({{ category.doc_count }})
            </label>
          </li>
        </ul>
      </div>
    </fieldset>

    <fieldset style='border:0;padding:0;margin:0'>
      <legend style='padding:10px 15px'>{{$t("dictionary.provider")}}</legend>
      <div class='mx-Bc(light-gray)' style='padding:15px;font-size:0.75em'>
        <ul style='list-style:none;margin:0;padding:0'>
          <li v-for='provider in aggregations.providers.buckets'>
            <label>
              <input v-model='filter.providers' :value="provider.key" type='checkbox' name='provider' style='vertical-align:middle;margin:0'>
              {{ provider.key }} ({{ provider.doc_count }})
            </label>
          </li>
        </ul>
      </div>
    </fieldset>

  </form>
</template>

<script>

  import _ from 'lodash';

  export default {

    props: {

      filter: {
        type: Object,
        default () {
          return {}
        }
      },

      aggregations: {
        type: Object,
        default () {
          return {}
        }
      }

    },

    data () {
      return {
        priceModel: {
          ranges: [],
          input: {
            active: false,
            min: 0,
            max: 2500
          }
        }
      }
    },

    watch: {
      filter: {
        handler (nVal, oVal) {
          this.$emit('changeFilter', nVal)
        },
        deep: true
      },


      'priceModel.input': {
        handler (nVal, oVal) {
          this.filter.price = [nVal.min, nVal.max]
        },
        deep: true
      },

      'priceModel.ranges': {
        handler (nVal, oVal) {
          this.filter.price = _.flatten(nVal)
        },
        deep: true
      }

    },

    computed: {

      showCategoriesFilter () {
        return !window.env_context.params.category
      },

      priceUpperBound () {
        return parseInt(this.aggregations.max_price.value)
      },

      priceFormat () {
        return "$ {value}"
      }

    }

  }
</script>

<style scoped lang='scss'>

.filter {
  &--is-disabled {
    color: #b5c6d2;
  }
}

</style>
