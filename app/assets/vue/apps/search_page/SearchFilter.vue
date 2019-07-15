<template>
  <form>
    <template v-if='mobileUx'>
      <div class='mobile-filter-wrapper'>
        <transition-group name='mobile-filter' tag='div'>
          <div v-show='!(isFiltering.root_audio || isFiltering.subtitles || isFiltering.category || isFiltering.provider_name || isFiltering.price)' class='mobile-filter-view mobile-filter-facets-view' key='mobile-filter-facets'>
            <div @click='isFiltering.root_audio = true' class='mobile-filter-facets__facet'>
              <search-fieldset :title='$t("dictionary.audios")' :subtitle="filter.root_audio.map(audioValue).join(', ')" :stand-out='filter.root_audio.length > 0'>
                <template #action>
                  <a class='c-fieldset-frame__action' href='#'>
                    <icon width='1rem' height='1rem' transform='rotate(-90deg)' name='arrow-down'></icon>
                  </a>
                </template>
              </search-fieldset>
            </div>

            <hr/>

            <template v-if="showCategoriesFilter">
              <div @click='isFiltering.category = true' class='mobile-filter-facets__facet'>
                <search-fieldset :title='$t("dictionary.categories")' v-if="showCategoriesFilter" :subtitle="filter.category.map(categoryValue).join(', ')" :stand-out='filter.category.length > 0'>
                  <template #action>
                    <a class='c-fieldset-frame__action' href='#'>
                      <icon width='1rem' height='1rem' transform='rotate(-90deg)' name='arrow-down'></icon>
                    </a>
                  </template>
                </search-fieldset>
              </div>

              <hr/>
            </template>

            <div @click='isFiltering.subtitles = true' class='mobile-filter-facets__facet'>
              <search-fieldset :title='$t("dictionary.subtitles")' :subtitle="filter.subtitles.map(subtitleValue).join(', ')" :stand-out='filter.subtitles.length > 0'>
                <template #action>
                  <a class='c-fieldset-frame__action' href='#'>
                    <icon width='1rem' height='1rem' transform='rotate(-90deg)' name='arrow-down'></icon>
                  </a>
                </template>
              </search-fieldset>
            </div>

            <hr/>

            <div @click='isFiltering.provider_name = true' class='mobile-filter-facets__facet'>
              <search-fieldset :title='$t("dictionary.providers")' :subtitle="filter.provider_name.map(providerValue).join(', ')" :stand-out='filter.provider_name.length > 0'>
                <template #action>
                  <a class='c-fieldset-frame__action' href='#'>
                    <icon width='1rem' height='1rem' transform='rotate(-90deg)' name='arrow-down'></icon>
                  </a>
                </template>
              </search-fieldset>
            </div>

            <hr/>

            <div @click='isFiltering.price = true' class='mobile-filter-facets__facet'>
              <search-fieldset :title='$t("dictionary.price")' :subtitle='`$ ${filter.price[0]} - $ ${filter.price[1]}`' :stand-out='filter.price[0] > 0 || filter.price[1] < 2500'>
                <template #action>
                  <a class='c-fieldset-frame__action' href='#'>
                    <icon width='1rem' height='1rem' transform='rotate(-90deg)' name='arrow-down'></icon>
                  </a>
                </template>
              </search-fieldset>
            </div>

            <hr/>

            <div class='mx-Pos(a) mx-B(0) mx-D(fx) mx-FxJc(sb) mx-FxAi(c) mx-Wd(100%)'>
              <a href='#' class='mx-C(magenta) mx-Fw(b)' @click="$emit('clearFiltersClicked')">
                {{ $t('dictionary.clear_all_filters') }}
              </a>

              <a href='#' class='btn btn--blue-flat' @click="$emit('showResultsClicked')">
                {{ $t('dictionary.show_results') }} ({{ total > 1000 ? '1000+' : total }})
              </a>
            </div>
          </div>
          <div v-show='isFiltering.root_audio' v-bar class='mobile-filter-view mobile-filter-options-view' key='mobile-filter-options__audio'>
            <search-facet-options :options='suggestions.root_audio.filtered'
                                  :filter='filter.root_audio'
                                  :rootClasses="['scrollable-ul--mobile']"
                                  :noOptionsMessage="$t('dictionary.no_options_available')"
                                  :checkboxClasses="['mx-Fs-1d25@extra-small']"
                                  @includeFacetOption="$emit('optionAddedToFilter', 'root_audio', $event)"
                                  @excludeFacetOption="$emit('optionRemovedFromFilter', 'root_audio', $event)">
            </search-facet-options>
            <div class='mx-Pos(a) mx-B(0) mx-D(fx) mx-FxJc(c) mx-Wd(100%)'>
              <a href='#' class='btn btn--blue-flat btn--block mx-Wd(30%) mx-Ta(c)' @click='isFiltering.root_audio = false'>
                OK
              </a>
            </div>
          </div>
          <div v-show='isFiltering.subtitles' v-bar class='mobile-filter-view mobile-filter-options-view' key='mobile-filter-options__subtitle'>
            <search-facet-options :options='suggestions.subtitles.filtered'
                                  :filter='filter.subtitles'
                                  :rootClasses="['scrollable-ul--mobile']"
                                  :noOptionsMessage="$t('dictionary.no_options_available')"
                                  :checkboxClasses="['mx-Fs-1d25@extra-small']"
                                  @includeFacetOption="$emit('optionAddedToFilter', 'subtitles', $event)"
                                  @excludeFacetOption="$emit('optionRemovedFromFilter', 'subtitles', $event)">
            </search-facet-options>
            <div class='mx-Pos(a) mx-B(0) mx-D(fx) mx-FxJc(c) mx-Wd(100%)'>
              <a href='#' class='btn btn--blue-flat btn--block mx-Wd(30%) mx-Ta(c)' @click='isFiltering.subtitles = false'>
                OK
              </a>
            </div>
          </div>
          <div v-show='isFiltering.category' v-bar class='mobile-filter-view mobile-filter-options-view' key='mobile-filter-options__category'>
            <search-facet-options :options='suggestions.category.filtered'
                                  :filter='filter.category'
                                  :rootClasses="['scrollable-ul--mobile']"
                                  :noOptionsMessage="$t('dictionary.no_options_available')"
                                  :checkboxClasses="['mx-Fs-1d25@extra-small']"
                                  @includeFacetOption="$emit('optionAddedToFilter', 'category', $event)"
                                  @excludeFacetOption="$emit('optionRemovedFromFilter', 'category', $event)">
            </search-facet-options>
            <div class='mx-Pos(a) mx-B(0) mx-D(fx) mx-FxJc(c) mx-Wd(100%)'>
              <a href='#' class='btn btn--blue-flat btn--block mx-Wd(30%) mx-Ta(c)' @click='isFiltering.category = false'>
                OK
              </a>
            </div>
          </div>
          <div v-show='isFiltering.provider_name' v-bar class='mobile-filter-view mobile-filter-options-view' key='mobile-filter-options__provider'>
            <search-facet-options :options='suggestions.provider_name.filtered'
                                  :filter='filter.provider_name'
                                  :rootClasses="['scrollable-ul--mobile']"
                                  :noOptionsMessage="$t('dictionary.no_options_available')"
                                  :checkboxClasses="['mx-Fs-1d25@extra-small']"
                                  @includeFacetOption="$emit('optionAddedToFilter', 'provider_name', $event)"
                                  @excludeFacetOption="$emit('optionRemovedFromFilter', 'provider_name', $event)">
            </search-facet-options>
            <div class='mx-Pos(a) mx-B(0) mx-D(fx) mx-FxJc(c) mx-Wd(100%)'>
              <a href='#' class='btn btn--blue-flat btn--block mx-Wd(30%) mx-Ta(c)' @click='isFiltering.provider_name = false'>
                OK
              </a>
            </div>
          </div>
          <div v-show='isFiltering.price' class='mobile-filter-view mobile-filter-options-view' key='mobile-filter-options__price'>
            <div style='margin-top: 30%;'>
              <div style='font-weight: bold; margin-bottom: 0.5em;text-align: center'>
                <span>$ {{ filter.price[0] }}</span> - <span>$ {{ filter.price[1] }}</span>
              </div>
              <search-facet-price-filter :initial-min='filter.price[0]'
                                         :initial-max='filter.price[1]'
                                         size='big'
                                         @priceValueChanged="$emit('priceValueChanged', $event)"
              >
              </search-facet-price-filter>
            </div>
            <div class='mx-Pos(a) mx-B(0) mx-D(fx) mx-FxJc(c) mx-Wd(100%)'>
              <a href='#' class='btn btn--blue-flat btn--block mx-Wd(30%) mx-Ta(c)' @click='isFiltering.price = false'>
                OK
              </a>
            </div>
          </div>
        </transition-group>
      </div>
    </template>
    <template v-else>
      <hr/>

      <search-fieldset :title='$t("dictionary.price")' :stand-out="true">
        <template #action>
          <a class='c-fieldset-frame__action mx-Ws(nw)' href='#' @click.prevent="$emit('clearFilterClicked','price')">
            {{ $t('dictionary.clear_filter') }}
          </a>
        </template>
        <div class='c-fieldset-frame__item'>
          <search-facet-price-filter :initial-min='filter.price[0]'
                                     :initial-max='filter.price[1]'
                                     :marks='[0,625,1250,1875,2500]'
                                     @priceValueChanged="$emit('priceValueChanged', $event)"
          >
          </search-facet-price-filter>

          <div style='margin-top: 2em;display:flex;'>
            <number-input :value='filter.price[0]' size="small" inline :min='0' :max='2500' @change="$emit('priceValueChanged', [$event, filter.price[1]])"></number-input>
            <span class='mx-D(ib)' style='margin: auto 0.5em; font-size: 0.875em; flex-basis: 150px;text-align:center;'> {{ $t('dictionary.in_currency',{currency: 'USD'}) }} </span>
            <number-input :value='filter.price[1]' size="small" inline :min='0' :max='2500' @change="$emit('priceValueChanged', [filter.price[0], $event])"></number-input>
          </div>
        </div>
      </search-fieldset>

      <hr/>

      <search-fieldset :title='$t("dictionary.providers")' :stand-out="true">
        <template #action>
          <a class='c-fieldset-frame__action mx-Ws(nw)' href='#' @click.prevent="$emit('clearFilterClicked','provider_name')">
            {{ $t('dictionary.clear_filter') }}
          </a>
        </template>
        <div class='c-fieldset-frame__item'>
          <search-facet-options-filter name='provider_name'
                                      :placeholder="`${$t('dictionary.search')} ${$t('dictionary.providers')} ...`"
                                      :suggestions='suggestions.provider_name.filtered'
                                      @changedInputFacetOptionSuggestion="suggestionInputChange('provider_name', ...$event)">
          </search-facet-options-filter>
        </div>
        <div class='c-fieldset-frame__item'>
          <search-facet-options :options='suggestions.provider_name.filtered'
                                :filter='filter.provider_name'
                                :noOptionsMessage="this.suggestions.provider_name.current && $t('dictionary.no_suggestions_message', {term: this.suggestions.provider_name.current})"
                                :noOptionsClasses="['mx-C(magenta) mx-Fs-0d75']"
                                @includeFacetOption="$emit('optionAddedToFilter', 'provider_name', $event)"
                                @excludeFacetOption="$emit('optionRemovedFromFilter', 'provider_name', $event)">
          </search-facet-options>
        </div>
      </search-fieldset>

      <hr/>

      <search-fieldset :title='$t("dictionary.audios")' :stand-out="true">
        <template #action>
          <a class='c-fieldset-frame__action mx-Ws(nw)' href='#' @click.prevent="$emit('clearFilterClicked','root_audio')">
            {{ $t('dictionary.clear_filter') }}
          </a>
        </template>
        <div class='c-fieldset-frame__item'>
          <search-facet-options-filter name='root_audio'
                                       :placeholder="`${$t('dictionary.search')} ${$t('dictionary.audios')} ...`"
                                       :suggestions='suggestions.root_audio.filtered'
                                       @changedInputFacetOptionSuggestion="suggestionInputChange('root_audio', ...$event)">
          </search-facet-options-filter>
        </div>
        <div class='c-fieldset-frame__item' v-bar>
          <search-facet-options :options='suggestions.root_audio.filtered'
                                :filter='filter.root_audio'
                                :rootClasses="['scrollable-ul']"
                                :noOptionsMessage="this.suggestions.root_audio.current && $t('dictionary.no_suggestions_message', {term: this.suggestions.root_audio.current})"
                                :noOptionsClasses="['mx-C(magenta) mx-Fs-0d75']"
                                @includeFacetOption="$emit('optionAddedToFilter', 'root_audio', $event)"
                                @excludeFacetOption="$emit('optionRemovedFromFilter', 'root_audio', $event)">
          </search-facet-options>
        </div>
      </search-fieldset>

      <template v-if="showCategoriesFilter">
        <hr/>

        <search-fieldset :title='$t("dictionary.categories")' :stand-out="true">
          <template #action>
            <a class='c-fieldset-frame__action mx-Ws(nw)' href='#' @click.prevent="$emit('clearFilterClicked','category')">
              {{ $t('dictionary.clear_filter') }}
            </a>
          </template>
          <div class='c-fieldset-frame__item'>
            <search-facet-options-filter name='category'
                                        :placeholder="`${$t('dictionary.search')} ${$t('dictionary.categories')} ...`"
                                        :suggestions='suggestions.category.filtered'
                                        @changedInputFacetOptionSuggestion="suggestionInputChange('category', ...$event)">
            </search-facet-options-filter>
          </div>
          <div class='c-fieldset-frame__item'>
            <search-facet-options :options='suggestions.category.filtered'
                                  :filter='filter.category'
                                  :noOptionsMessage="this.suggestions.category.current && $t('dictionary.no_suggestions_message', {term: this.suggestions.category.current})"
                                  :noOptionsClasses="['mx-C(magenta) mx-Fs-0d75']"
                                  @includeFacetOption="$emit('optionAddedToFilter', 'category', $event)"
                                  @excludeFacetOption="$emit('optionRemovedFromFilter', 'category', $event)">
            </search-facet-options>
          </div>
        </search-fieldset>
      </template>

      <hr/>

      <search-fieldset :title='$t("dictionary.subtitles")' :stand-out="true">
        <template #action>
          <a class='c-fieldset-frame__action mx-Ws(nw)' href='#' @click.prevent="$emit('clearFilterClicked','subtitles')">
            {{ $t('dictionary.clear_filter') }}
          </a>
        </template>
        <div class='c-fieldset-frame__item'>
          <search-facet-options-filter name='subtitles'
                                       :placeholder="`${$t('dictionary.search')} ${$t('dictionary.subtitles')} ...`"
                                       :suggestions='suggestions.subtitles.filtered'
                                       @changedInputFacetOptionSuggestion="suggestionInputChange('subtitles', ...$event)">
          </search-facet-options-filter>
        </div>
        <div class='c-fieldset-frame__item' v-bar>
          <search-facet-options :options='suggestions.subtitles.filtered'
                                :filter='filter.subtitles'
                                :rootClasses="['scrollable-ul']"
                                :noOptionsMessage="this.suggestions.subtitles.current && $t('dictionary.no_suggestions_message', {term: this.suggestions.subtitles.current})"
                                :noOptionsClasses="['mx-C(magenta) mx-Fs-0d75']"
                                @includeFacetOption="$emit('optionAddedToFilter', 'subtitles', $event)"
                                @excludeFacetOption="$emit('optionRemovedFromFilter', 'subtitles', $event)">
          </search-facet-options>
        </div>
      </search-fieldset>
    </template>
  </form>
</template>

<script>
  import _ from 'lodash';
  import VueNumberInput from '@chenfengyuan/vue-number-input';
  import Icon from '../../shared/Icon.vue';
  import Fieldset from './SearchFilter/Fieldset.vue';
  import FacetOptions from './SearchFilter/FacetOptions.vue';
  import FacetOptionsFilter from './SearchFilter/FacetOptionsFilter.vue';
  import FacetPriceFilter from './SearchFilter/FacetPriceFilter.vue';

  export default {

    props: {
      mobileUx: {
        type: Boolean,
        default: false
      },
      filter: {
        type: Object,
        default () {
          return {
            root_audio: [],
            subtitles: [],
            category: [],
            provider_name: []
          }
        }
      },
      aggregations: {
        type: Object,
        default () {
          return {}
        }
      },
      total: {
        type: Number,
        default: 0
      }
    },

    components: {
      'number-input': VueNumberInput,
      'search-fieldset': Fieldset,
      'search-facet-options': FacetOptions,
      'search-facet-options-filter': FacetOptionsFilter,
      'search-facet-price-filter': FacetPriceFilter,
      'icon': Icon
    },

    data () {
      return {
        isFiltering: {
          root_audio: false,
          subtitles: false,
          category: false,
          provider_name: false,
          price: false
        },
        suggestions: {
          root_audio: {
            source: [],
            filtered: []
          },
          subtitles: {
            source: [],
            filtered: []
          },
          category: {
            source: [],
            filtered: []
          },
          provider_name: {
            source: [],
            filtered: []
          }
        }
      }
    },

    created() {
      this.copyAggregationBuckets(this.aggregations);
    },

    watch: {
      'aggregations': {
        handler (nVal, oVal) {
          this.copyAggregationBuckets(nVal);
        }
      }
    },

    methods: {
      copyAggregationBuckets: function(aggregations){
        this.suggestions.root_audio.source      = aggregations.root_audio.buckets.map(({key, doc_count}) => Object.assign({}, {id: key, name: this.audioValue(key), count: doc_count}));
        this.suggestions.root_audio.filtered    = this.suggestions.root_audio.source;

        this.suggestions.subtitles.source   = aggregations.subtitles.buckets.map(({key, doc_count}) => Object.assign({}, {id: key, name: this.subtitleValue(key), count: doc_count}));
        this.suggestions.subtitles.filtered = this.suggestions.subtitles.source;

        this.suggestions.category.source   = aggregations.category.buckets.map(({key, doc_count}) => Object.assign({}, {id: key, name: this.categoryValue(key), count: doc_count}));
        this.suggestions.category.filtered = this.suggestions.category.source;

        this.suggestions.provider_name.source   = aggregations.provider_name.buckets.map(({key, doc_count}) => Object.assign({}, {id: key, name: this.providerValue(key), count: doc_count}));
        this.suggestions.provider_name.filtered = this.suggestions.provider_name.source;
      },
      suggestionInputChange: function(key, text, _) {
        this.suggestions[key].current  = text;

        if (text === null) {
          this.suggestions[key].filtered = this.suggestions[key].source;
          return ;
        }

        const filteredData = this.suggestions[key].source.filter(option => {
          return option.name.toLowerCase().indexOf(text.toLowerCase()) > -1;
        });

        this.suggestions[key].filtered = filteredData;
      },
      audioValue: function(key) {
        return this.$t(`iso639_codes.${key}`);
      },
      subtitleValue: function(key){
        return this.$t(`iso639_codes.${key}`);
      },
      categoryValue: function(key){
        return this.$t(`tags.${key}`);
      },
      providerValue: function(key) {
        return key;
      }
    },

    computed: {

      showCategoriesFilter () {
        return !window.env_context.params.category.length
      },

      priceUpperBound () {
        return parseInt(this.aggregations.max_price.value)
      },

      priceFormat () {
        return "$ {value}"
      },

      arrowDownIcon () {
        return `${window.iconsLibPath}#arrow-down`;
      }

    }

  }
</script>

<style scoped lang='scss'>
@import '~elements/src/scss/config/variables.scss';
@import '~elements/src/scss/config/functions.scss';

form {
  margin: 0;
}

hr {
  margin-bottom: 1em;
  border: none;
  border-top: 1px solid #DEE7ED;
}

.mobile-filter-wrapper {
  height: 100%;
  box-sizing: border-box;

  hr {
    margin-top: 0;
  }
}

.mobile-filter-wrapper > div {
  height: 100%;
  position: relative;
}

.mobile-filter-view {
  position:absolute;
  width:100%;
  height:100%;
}

.mobile-filter-facets__facet {
  cursor: pointer;
}

.mobile-filter-enter-active, .mobile-filter-enter, .mobile-filter-leave, .filter-leave-active {
  transition: all 0.5s;
}

.mobile-filter-enter.mobile-filter-facets-view {
  transform: translateX(-100%);
}

.mobile-filter-leave-active.mobile-filter-options-view {
  transform: translateX(100%);
}

.mobile-filter-enter.mobile-filter-options-view {
  transform: translateX(100%);
}

.mobile-filter-leave-active.mobile-filter-facets-view {
  transform: translateX(-100%);
}

.scrollable-ul {
  max-height: 200px;
  height: auto !important;
}

.scrollable-ul--mobile {
  max-height: 70%;
  height: auto !important;
}

.filter {
  &--is-disabled {
    color: #b5c6d2;
  }
}
</style>
