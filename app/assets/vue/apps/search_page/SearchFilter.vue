<template>
  <form>
    <template v-if='mobileUx'>
      <div class='mobile-filter-wrapper'>
        <transition-group name='mobile-filter' tag='div'>
          <div v-show='!(isFiltering.audios || isFiltering.subtitles || isFiltering.categories || isFiltering.providers || isFiltering.price)' class='mobile-filter-view mobile-filter-facets-view' key='mobile-filter-facets__audio'>
            <search-fieldset :title='$t("dictionary.audio")' :subtitle="filter.audios.map(audioValue).join(', ')" :stand-out='filter.audios.length > 0'>
              <template #action>
                <a class='c-fieldset-frame__action' href='#' @click='isFiltering.audios = true'>
                  <icon width='1rem' height='1rem' transform='rotate(-90deg)' name='arrow-down'></icon>
                </a>
              </template>
            </search-fieldset>

            <hr/>

            <search-fieldset :title='$t("dictionary.subtitles")' :subtitle="filter.subtitles.map(subtitleValue).join(', ')" :stand-out='filter.subtitles.length > 0'>
              <template #action>
                <a class='c-fieldset-frame__action' href='#' @click='isFiltering.subtitles = true'>
                  <icon width='1rem' height='1rem' transform='rotate(-90deg)' name='arrow-down'></icon>
                </a>
              </template>
            </search-fieldset>

            <hr/>

            <search-fieldset :title='$t("dictionary.categories")' v-if="showCategoriesFilter" :subtitle="filter.categories.map(categoryValue).join(', ')" :stand-out='filter.categories.length > 0'>
              <template #action>
                <a class='c-fieldset-frame__action' href='#' @click='isFiltering.categories = true'>
                  <icon width='1rem' height='1rem' transform='rotate(-90deg)' name='arrow-down'></icon>
                </a>
              </template>
            </search-fieldset>

            <hr/>

            <search-fieldset :title='$t("dictionary.provider")' :subtitle="filter.providers.map(providerValue).join(', ')" :stand-out='filter.providers.length > 0'>
              <template #action>
                <a class='c-fieldset-frame__action' href='#' @click='isFiltering.providers = true'>
                  <icon width='1rem' height='1rem' transform='rotate(-90deg)' name='arrow-down'></icon>
                </a>
              </template>
            </search-fieldset>

            <hr/>

            <search-fieldset :title='$t("dictionary.price")' :subtitle='`$ ${filter.price[0]} - $ ${filter.price[1]}`' :stand-out='filter.price[0] > 0 || filter.price[1] < 2500'>
              <template #action>
                <a class='c-fieldset-frame__action' href='#' @click='isFiltering.price = true'>
                  <icon width='1rem' height='1rem' transform='rotate(-90deg)' name='arrow-down'></icon>
                </a>
              </template>
            </search-fieldset>

            <hr/>

            <div class='mx-Pos(a) mx-B(0) mx-D(fx) mx-FxJc(sb) mx-FxAi(c) mx-Wd(100%)'>
              <a href='#' class='mx-C(magenta) mx-Fw(b)' @click="$emit('clearFiltersClicked')">
                Clear all filters
              </a>

              <a href='#' class='btn btn--blue-flat' @click="$emit('showResultsClicked')">
                Show Results ({{ total > 1000 ? '1000+' : total }})
              </a>
            </div>
          </div>
          <div v-show='isFiltering.audios' v-bar class='mobile-filter-view mobile-filter-options-view' key='mobile-filter-options__audio'>
            <search-facet-options :options='suggestions.audios.filtered'
                                  :filter='filter.audios'
                                  :rootClasses="['scrollable-ul--mobile']"
                                  @includeFacetOption="$emit('optionAddedToFilter', 'audios', $event)"
                                  @excludeFacetOption="$emit('optionRemovedFromFilter', 'audios', $event)">
            </search-facet-options>
            <div class='mx-Pos(a) mx-B(0) mx-D(fx) mx-FxJc(c) mx-Wd(100%)'>
              <a href='#' class='btn btn--blue-flat btn--block mx-Wd(30%) mx-Ta(c)' @click='isFiltering.audios = false'>
                OK
              </a>
            </div>
          </div>
          <div v-show='isFiltering.subtitles' v-bar class='mobile-filter-view mobile-filter-options-view' key='mobile-filter-options__subtitle'>
            <search-facet-options :options='suggestions.subtitles.filtered'
                                  :filter='filter.subtitles'
                                  :rootClasses="['scrollable-ul--mobile']"
                                  @includeFacetOption="$emit('optionAddedToFilter', 'subtitles', $event)"
                                  @excludeFacetOption="$emit('optionRemovedFromFilter', 'subtitles', $event)">
            </search-facet-options>
            <div class='mx-Pos(a) mx-B(0) mx-D(fx) mx-FxJc(c) mx-Wd(100%)'>
              <a href='#' class='btn btn--blue-flat btn--block mx-Wd(30%) mx-Ta(c)' @click='isFiltering.subtitles = false'>
                OK
              </a>
            </div>
          </div>
          <div v-show='isFiltering.categories' v-bar class='mobile-filter-view mobile-filter-options-view' key='mobile-filter-options__category'>
            <search-facet-options :options='suggestions.categories.filtered'
                                  :filter='filter.categories'
                                  :rootClasses="['scrollable-ul--mobile']"
                                  @includeFacetOption="$emit('optionAddedToFilter', 'categories', $event)"
                                  @excludeFacetOption="$emit('optionRemovedFromFilter', 'categories', $event)">
            </search-facet-options>
            <div class='mx-Pos(a) mx-B(0) mx-D(fx) mx-FxJc(c) mx-Wd(100%)'>
              <a href='#' class='btn btn--blue-flat btn--block mx-Wd(30%) mx-Ta(c)' @click='isFiltering.categories = false'>
                OK
              </a>
            </div>
          </div>
          <div v-show='isFiltering.providers' v-bar class='mobile-filter-view mobile-filter-options-view' key='mobile-filter-options__provider'>
            <search-facet-options :options='suggestions.providers.filtered'
                                  :filter='filter.providers'
                                  :rootClasses="['scrollable-ul--mobile']"
                                  @includeFacetOption="$emit('optionAddedToFilter', 'providers', $event)"
                                  @excludeFacetOption="$emit('optionRemovedFromFilter', 'providers', $event)">
            </search-facet-options>
            <div class='mx-Pos(a) mx-B(0) mx-D(fx) mx-FxJc(c) mx-Wd(100%)'>
              <a href='#' class='btn btn--blue-flat btn--block mx-Wd(30%) mx-Ta(c)' @click='isFiltering.providers = false'>
                OK
              </a>
            </div>
          </div>
          <div v-show='isFiltering.price' class='mobile-filter-view mobile-filter-options-view' key='mobile-filter-options__price'>
            <div style='margin-top: 30%;'>
              <div style='font-weight: bold; margin-bottom: 0.5em;text-align: center'>
                <span>$ {{ filter.price[0] }}</span> - <span>$ {{ filter.price[1] }}</span>
              </div>
              <search-facet-price-filter :current-min='parseFloat(filter.price[0])'
                                         :current-max='parseFloat(filter.price[1])'
                                         @priceLowerValueChanged="$emit('priceLowerValueChanged', $event)"
                                         @priceUpperValueChanged="$emit('priceUpperValueChanged', $event)"
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

      <search-fieldset :title='$t("dictionary.audio")' :stand-out="true">
        <template #action>
          <a class='c-fieldset-frame__action' href='#' @click.prevent="$emit('clearFilterClicked','audios')">Clear filters</a>
        </template>
        <div class='c-fieldset-frame__item'>
          <search-facet-options-filter name='audios'
                                       placeholder='Search language ...'
                                       :suggestions='suggestions.audios.filtered'
                                       @changedInputFacetOptionSuggestion="suggestionInputChange('audios', ...$event)">
          </search-facet-options-filter>
        </div>
        <div class='c-fieldset-frame__item' v-bar>
          <search-facet-options :options='suggestions.audios.filtered'
                                :filter='filter.audios'
                                :rootClasses="['scrollable-ul']"
                                @includeFacetOption="$emit('optionAddedToFilter', 'audios', $event)"
                                @excludeFacetOption="$emit('optionRemovedFromFilter', 'audios', $event)">
          </search-facet-options>
        </div>
      </search-fieldset>

      <hr/>

      <search-fieldset :title='$t("dictionary.subtitles")' :stand-out="true">
        <template #action>
          <a class='c-fieldset-frame__action' href='#' @click.prevent="$emit('clearFilterClicked','subtitles')">Clear filters</a>
        </template>
        <div class='c-fieldset-frame__item'>
          <search-facet-options-filter name='subtitles'
                                       placeholder='Search subtitle ...'
                                       :suggestions='suggestions.subtitles.filtered'
                                       @changedInputFacetOptionSuggestion="suggestionInputChange('subtitles', ...$event)">
          </search-facet-options-filter>
        </div>
        <div class='c-fieldset-frame__item' v-bar>
          <search-facet-options :options='suggestions.subtitles.filtered'
                                :filter='filter.subtitles'
                                :rootClasses="['scrollable-ul']"
                                @includeFacetOption="$emit('optionAddedToFilter', 'subtitles', $event)"
                                @excludeFacetOption="$emit('optionRemovedFromFilter', 'subtitles', $event)">
          </search-facet-options>
        </div>
      </search-fieldset>

      <template v-if="showCategoriesFilter">
        <hr/>

        <search-fieldset :title='$t("dictionary.categories")' :stand-out="true">
          <template #action>
            <a class='c-fieldset-frame__action' href='#' @click.prevent="$emit('clearFilterClicked','categories')">Clear filters</a>
          </template>
          <div class='c-fieldset-frame__item'>
            <search-facet-options-filter name='categories'
                                        placeholder='Search category ...'
                                        :suggestions='suggestions.categories.filtered'
                                        @changedInputFacetOptionSuggestion="suggestionInputChange('categories', ...$event)">
            </search-facet-options-filter>
          </div>
          <div class='c-fieldset-frame__item' v-bar>
            <search-facet-options :options='suggestions.categories.filtered'
                                  :filter='filter.categories'
                                  :rootClasses="['scrollable-ul']"
                                  @includeFacetOption="$emit('optionAddedToFilter', 'categories', $event)"
                                  @excludeFacetOption="$emit('optionRemovedFromFilter', 'categories', $event)">
            </search-facet-options>
          </div>
        </search-fieldset>
      </template>

      <hr/>

      <search-fieldset :title='$t("dictionary.provider")' :stand-out="true">
        <template #action>
          <a class='c-fieldset-frame__action' href='#' @click.prevent="$emit('clearFilterClicked','providers')">Clear filters</a>
        </template>
        <div class='c-fieldset-frame__item'>
          <search-facet-options-filter name='providers'
                                      placeholder='Search provider ...'
                                      :suggestions='suggestions.providers.filtered'
                                      @changedInputFacetOptionSuggestion="suggestionInputChange('providers', ...$event)">
          </search-facet-options-filter>
        </div>
        <div class='c-fieldset-frame__item' v-bar>
          <search-facet-options :options='suggestions.providers.filtered'
                                :filter='filter.providers'
                                :rootClasses="['scrollable-ul']"
                                @includeFacetOption="$emit('optionAddedToFilter', 'providers', $event)"
                                @excludeFacetOption="$emit('optionRemovedFromFilter', 'providers', $event)">
          </search-facet-options>
        </div>
      </search-fieldset>

      <hr/>

      <search-fieldset :title='$t("dictionary.price")' :stand-out="true">
        <template #action>
          <a class='c-fieldset-frame__action' href='#' @click.prevent="$emit('clearFilterClicked','price')">Clear filters</a>
        </template>
        <div class='c-fieldset-frame__item'>
          <search-facet-price-filter :current-min='parseFloat(filter.price[0])'
                                     :current-max='parseFloat(filter.price[1])'
                                     :marks='[0,625,1250,1875,2500]'
                                     @priceLowerValueChanged="$emit('priceLowerValueChanged', $event)"
                                     @priceUpperValueChanged="$emit('priceUpperValueChanged', $event)"
          >
          </search-facet-price-filter>

          <div style='margin-top: 2em;display:flex;'>
            <number-input :value='parseFloat(filter.price[0])' size="small" inline :min='0' :max='2500' @change="$emit('priceLowerValueChanged', $event)"></number-input>
            <span class='mx-D(ib)' style='margin: auto 0.5em; font-size: 0.875em; flex-basis: 150px;text-align:center;'> in USD </span>
            <number-input :value='parseFloat(filter.price[1])' size="small" inline :min='0' :max='2500' @change="$emit('priceUpperValueChanged', $event)"></number-input>
          </div>
        </div>
      </search-fieldset>

    </template>
  </form>
</template>

<script>
  import _ from 'lodash';
  import VueNumberInput from '@chenfengyuan/vue-number-input';
  import Icon from './Icon.vue';
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
            audios: [],
            subtitles: [],
            categories: [],
            providers: []
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
          audios: false,
          subtitles: false,
          categories: false,
          providers: false,
          price: false
        },
        priceModel: {
          min: 0,
          max: 2500
        },
        suggestions: {
          audios: {
            source: [],
            filtered: []
          },
          subtitles: {
            source: [],
            filtered: []
          },
          categories: {
            source: [],
            filtered: []
          },
          providers: {
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
        this.suggestions.audios.source      = aggregations.audios.buckets.map(({key, doc_count}) => Object.assign({}, {id: key, name: this.audioValue(key), count: doc_count}));
        this.suggestions.audios.filtered    = this.suggestions.audios.source;

        this.suggestions.subtitles.source   = aggregations.subtitles.buckets.map(({key, doc_count}) => Object.assign({}, {id: key, name: this.subtitleValue(key), count: doc_count}));
        this.suggestions.subtitles.filtered = this.suggestions.subtitles.source;

        this.suggestions.categories.source   = aggregations.categories.buckets.map(({key, doc_count}) => Object.assign({}, {id: key, name: this.categoryValue(key), count: doc_count}));
        this.suggestions.categories.filtered = this.suggestions.categories.source;

        this.suggestions.providers.source   = aggregations.providers.buckets.map(({key, doc_count}) => Object.assign({}, {id: key, name: this.providerValue(key), count: doc_count}));
        this.suggestions.providers.filtered = this.suggestions.providers.source;
      },
      suggestionInputChange: function(key, text, _) {
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
      },
      log: function(params){
        console.log(params);
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

.mobile-filter-enter-active, .mobile-filter-enter, .mobile-filter-leave, .filter-leave-active {
  transition: all 1s;
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
