<template>
  <div>
    <modal :adaptive="true" width='100%' height='100%' name='mobileFilter'>
      <div class='filter-nav--mobile'>
        <div class='mx-D(Fx) mx-FxJc(sb)' style='height: 15%;'>
          <h5>{{ $t('dictionary.filters') }}</h5>
          <a href='#' @click="hideMobileFilter">
            <icon width='1.05rem' height='1.05rem' name='close'></icon>
          </a>
        </div>
        <div style='height: 85%;'>
          <search-filter :aggregations='data.meta.aggregations'
                         :total='data.meta.total'
                         :filter='params.filter'
                         :mobileUx='true'
                         @showResultsClicked="hideMobileFilter"
                         @clearFiltersClicked="clearFilters"
                         @optionAddedToFilter="addOptionToFilter"
                         @optionRemovedFromFilter="removeOptionFromFilter"
                         @priceValueChanged="changePriceValue">
          </search-filter>
        </div>
      </div>
    </modal>

    <div class='container mx-Pb(60px)'>
      <div class='row'>
        <div class='mx-D(n)@<medium col-lg-3'>
          <span style='font-size:0.875em;display:inline-block;line-height:1.15em;padding:20px 0'></span>
        </div>
        <div class='col-12 col-lg-9'>
          <span style='display:inline-block;line-height:1em;font-size:0.875em;padding:20px 0;width:100%'>
            {{ $t('dictionary.search_results', { total: data.meta.total }) }}

            <template v-if='params.q'>
              {{ $t('dictionary.for') }} <span class='query-tag'>{{ this.params.q }}</span>
            </template>

          </span>

          <div class='mx-D(Fx) mx-FxJc(sb) mx-FxAi(c)'>
            <div>
              <pagination @paginate='paginate' pagination-anchor='#body-anchor' :current-page='page' :num-of-pages='numOfPages' :records-per-page='recordsPerPage'></pagination>
            </div>
            <div class='mx-D(n)@<medium mx-D(Fx) mx-FxAi(c) sort'>
              <span class='mx-D(b) mx-Mr-1 sort__label'>{{ $t('dictionary.sort_by') }}</span>
              <multiselect  :value="orderCurrentOption"
                            @select="sortByChanged"
                            track-by='key'
                            label='i18n_key'
                            :custom-label="({i18n_key}) => { return $t(`dictionary.${i18n_key}`); }"
                            select-label=''
                            selected-label=''
                            deselect-label=''
                            :show-pointer='true'
                            @open='orderOptionsToggled = true'
                            @close='orderOptionsToggled = false'
                            :options='orderOptions'
                            :searchable='false'
                            :allow-empty='false'>
                <template slot='caret' slot-scope="{toggle}">
                  <div @mousedown.prevent.stop="orderOptionsToggle(toggle)" class='sort__caret'>
                    <icon width='1rem' height='1rem' :transform='`rotate(${orderOptionsToggled ? 180 : 0}deg)`'  name='arrow-down'></icon>
                  </div>
                </template>
              </multiselect>
            </div>
          </div>
        </div>
      </div>

      <div class='row mx-Mt-1@>large'>
        <div class='mx-D(n)@<medium col-lg-3'>
          <div class='filter-nav'>
            <div class='mx-D(Fx) mx-FxJc(sb)'>
              <h4>{{ $t('dictionary.filters') }}</h4>
              <a href='#' class='mx-C(magenta) mx-Fw(b)' @click.prevent="clearFilters" style="margin: auto 0;text-align:right;">
                {{ $t('dictionary.clear_all_filters') }}
              </a>
            </div>
            <search-filter :aggregations='data.meta.aggregations'
                           :filter='params.filter'
                           @clearFilterClicked='clearFilter'
                           @optionAddedToFilter="addOptionToFilter"
                           @optionRemovedFromFilter="removeOptionFromFilter"
                           @priceValueChanged="changePriceValue">
            </search-filter>
          </div>
        </div>

        <div class='col-12 mx-D(n)@>desktop mx-Mb-1'>
          <hr/>
          <div class='mx-D(Fx) mx-FxJc(sb) mx-FxAi(c)'>
            <span class='mx-C(blue) mx-Fw(b)'>
              {{ $t('dictionary.sort_by') }}
              <select :value="orderCurrentOption.key" @change='sortByChanged({key: $event.target.value})'>
                <option v-for='option in orderOptions' :key='option.key' :value='option.key'>
                  {{ $t(`dictionary.${option.i18n_key}`) }}
                </option>
              </select>
            </span>
            <a class='mx-C(blue) mx-Fw(b) mx-Ws(nw)' href='#' @click="showMobileFilter">
              {{ $t('dictionary.filter_results') }}
            </a>
          </div>
        </div>

        <div class='col-12 col-lg-9 vld-parent'>
          <loading :active.sync="isLoadable" :is-full-page='true' color='#4C636F'></loading>
          <course-list :courses='data.records'></course-list>
          <pagination @paginate='paginate' pagination-anchor='#results' :records-per-page='recordsPerPage' :current-page='page' :num-of-pages='numOfPages'></pagination>
        </div>

      </div>
    </div>
  </div>
</template>

<script>
  import _ from 'lodash';
  import CourseList from './CourseList.vue';
  import Pagination from './Pagination.vue';
  import SearchFilter from './SearchFilter.vue';
  import Icon from './Icon.vue';
  import qs from 'qs';
  import Loading from "vue-loading-overlay";
  import 'vue-loading-overlay/dist/vue-loading.css';
  import Multiselect from 'vue-multiselect';

  export default {
    props: {

      recordsPerPage: {
        type: Number,
        default: 25
      },

      category: {
        type: Array,
        default() {
          return [];
        }
      },

      showCategoriesFilter: {
        type: Boolean,
        default: true
      },

      containerClass: {
        type: String,
        default: ''
      },

      locale: {
        type: String,
        default: 'en'
      },

      searchEndpoint: {
        type: String,
        default: 'search.json'
      }

    },
    components: {
      courseList: CourseList,
      searchFilter: SearchFilter,
      pagination: Pagination,
      icon: Icon,
      loading: Loading,
      multiselect: Multiselect
    },
    data () {
      return {
        params: this.defaultParams(null),
        isFetchingRecords: false,
        mobileFilterHidden: true,
        isMobile: this.isCurrentViewportMobile(),
        numOfPages: 0,
        orderCurrentOption: this.orderOptionByKey("rel"),
        orderOptionsToggled: false,
        orderOptionsToggle: function(callback) { this.orderOptionsToggled = !this.orderOptionsToggled; callback(); },
        data: {
          meta: {
            aggregations: {
              root_audio: {
                buckets: []
              },
              subtitles: {
                buckets: []
              },
              provider_name: {
                buckets: []
              },
              max_price: {
                value: undefined
              },
              category: {
                buckets: []
              }
            }

          },
          records: []
        }
      }
    },
    watch: {
      'data.meta.total': function (nVal, oVal) {
        let total       = Math.min(nVal, 10000); // 10000 is the default max window for ES
        this.numOfPages = parseInt(Math.ceil(total/this.recordsPerPage));
      }
    },
    computed: {
      page () {
        return (parseInt(this.params.p) || 1)
      },
      isLoadable() {
        return (!this.isMobile || (this.isMobile && this.mobileFilterHidden)) && this.isFetchingRecords;
      },
      orderOptions() {
        return this.$classpert.orderOptions;
      }
    },
    beforeCreate() {
      this.$classpert.orderOptions = [
        { key: 'rel',        value: {},                i18n_key: 'relevance' },
        { key: 'price.asc',  value: { price: "asc" },  i18n_key: 'lowest_price' },
        { key: 'price.desc', value: { price: "desc" }, i18n_key: 'highest_price' }
      ];
    },
    mounted () {
      this.$i18n.locale = this.locale

      let categoryFilter = {}
      if (this.category) {
        categoryFilter = { filter: { category: this.category } }
      }

      let queryParams = qs.parse(window.location.search.replace('?', ''), { arrayFormat: 'brackets' });

      if (_.get(queryParams, 'filter.price')) {
        queryParams.filter.price = queryParams.filter.price.map(parseFloat);
      }

      if (_.get(queryParams, 'order')) {
        this.orderCurrentOption = this.orderOptionByValue(_.get(queryParams, 'order')) || this.orderOptionByKey("rel");
      }

      this.params = _.merge(this.params, categoryFilter, queryParams);

      // only start watching params after initial setup during mount
      // otherwise will double trigger record fetching
      this.$watch('params', function (nVal, oVal) { if (!_.isEqual(nVal,oVal)) { this.fetchResults(); } }, {deep: true});

      this.fetchResults();
    },
    methods: {
      isCurrentViewportMobile() {
        let w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
        return w < parseInt(window.Elements.breakpoints.lg);
      },
      showMobileFilter() {
        this.mobileFilterHidden = false;
        this.$modal.show('mobileFilter');
      },
      hideMobileFilter() {
        this.mobileFilterHidden = true;
        this.$modal.hide('mobileFilter');
      },
      orderOptionByKey(key) {
        return _.find(this.$classpert.orderOptions, (o) => { return o.key === key });
      },
      orderOptionByValue(value) {
        return _.find(this.$classpert.orderOptions, (o) => { return _.isEqual(o.value, value);  });
      },
      paginate (page) {
        this.params = this.changeFilters([
          {
            filter: 'p',
            value: parseInt(page || 1)
          }
        ]);
      },
      clearFilters () {
        this.params = this.defaultParams(this.params.q);
      },
      clearFilter (filter) {
        if (filter === 'price') {
          this.params = this.changePriceValue([0, 2500]);
        } else {
          this.params = this.changeFilters([
            {
              filter: `filter.${filter}`,
              value: []
            }
          ]);
        }
      },
      addOptionToFilter (key, option) {
        this.params = this.changeFilters([
          {
            filter: `filter.${key}`,
            value: _.concat(this.params.filter[key], [option])
          }
        ]);
      },
      removeOptionFromFilter (key, option) {
        this.params = this.changeFilters([
          {
            filter: `filter.${key}`,
            value: _.without(this.params.filter[key], option)
          }
        ]);
      },
      changePriceValue (value) {
        this.params = this.changeFilters([
          {
            filter: 'filter.price',
            value: value
          }
        ]);
      },
      changeFilters(filters) {
        // go back to first page when filtering
        filters.unshift({ filter: 'p', value: 1 });
        return filters.reduce((acc, {filter, value}) => _.set(acc, filter, value), _.cloneDeep(this.params));
      },
      sortByChanged ({key}) {
        let orderOption         = this.orderOptionByKey(key);
        this.orderCurrentOption = orderOption;
        this.params             = this.changeFilters([
          {
            filter: 'order',
            value: orderOption.value
          }
        ]);
      },
      defaultParams: function (currentQuery) {
        return {
          order: {},
          filter: {
            provider_name: [],
            category:      [],
            root_audio:    [],
            subtitles:     [],
            price:         [0, 2500]
          },
          p: 1,
          q: currentQuery
        };
      },
      fetchResults () {
        var vm  = this
        var stringifiedParams = qs.stringify(this.params, {indices: false, arrayFormat: 'brackets', encode: true})
        var url = `${this.searchEndpoint}?${stringifiedParams}`
        window.history.replaceState({}, 'foo', url.replace('.json', ''))

        vm.isFetchingRecords = true;
        fetch(url, { method: 'GET' }).then(function (resp) {
          resp.json().then(function (json) {
            vm.data.records      = json.data;
            vm.data.meta         = json.meta;
            vm.isFetchingRecords = false;
          })
        });
      }
    }
  }
</script>

<style scoped lang='scss'>
hr {
  margin-bottom: 1em;
  border: none;
  border-top: 1px solid #DEE7ED;
}

.sort {
  flex-basis: 260px;

  .sort__label {
    white-space: nowrap;
  }

  .sort__caret {
    position: absolute;
    width: 40px;
    right: 1px;
    top: 8px;
    padding: 4px 8px;
    text-align: center;
    cursor: pointer;
    svg {
      transition: transform .2s ease;
    }
  }
}

.filter-nav {
  top: 50;
  background-color: white;
  padding: 1.5em;
}

.filter-nav--mobile {
  padding: 1.25em;
  height: calc(100% - 2 * 1.25em);
  box-sizing: content-box;
}

.query-tag {
  padding:5px 10px;
  font-size:0.9em;
  color:#fff;
  border-radius:3px;
  background-color:#4c71a5;
}

</style>
