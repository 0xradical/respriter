<template>
  <div>
    <modal :adaptive="true" width='100%' height='100%' name='mobileFilter'>
      <div class='filter-nav--mobile'>
        <div class='mx-D(Fx) mx-FxJc(sb)' style='height: 15%;'>
          <h5>{{ $t('dictionary.filters') }}</h5>
          <a href='#' @click="$modal.hide('mobileFilter')">
            <icon width='1.05rem' height='1.05rem' name='close'></icon>
          </a>
        </div>
        <div style='height: 85%;'>
          <search-filter :aggregations='data.meta.aggregations'
                         :total='data.meta.total'
                         :filter='params.filter'
                         :mobileUx='true'
                         @showResultsClicked="$modal.hide('mobileFilter')"
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
              <pagination @paginate='paginate' pagination-anchor='#body-anchor' :current-page='page' :num-of-pages='numOfPages'></pagination>
            </div>
            <div class='mx-D(n)@<medium'>
              <span>
                {{ $t('dictionary.sort_by') }}
                <select v-model='params.order.price'>
                  <option value='asc'>{{ $t('dictionary.lowest_price') }}</option>
                  <option value='desc'>{{ $t('dictionary.highest_price') }}</option>
                </select>
              </span>
            </div>
          </div>

        </div>
      </div>

      <div class='row'>
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
              <select v-model='params.order.price'>
                <option value='asc'>{{ $t('dictionary.lowest_price') }}</option>
                <option value='desc'>{{ $t('dictionary.highest_price') }}</option>
              </select>
            </span>
            <a class='mx-C(blue) mx-Fw(b) mx-Ws(nw)' href='#' @click="$modal.show('mobileFilter')">
              {{ $t('dictionary.filter_results') }}
            </a>
          </div>
        </div>

        <div class='col-12 col-lg-9 vld-parent'>
          <loading :active.sync="isLoadable" :is-full-page='true' color='#4C636F'></loading>
          <template v-if="data.records.length > 0">
            <div v-for='course in data.records' :key="course.id" style='margin-bottom:10px'>
              <course :course='course'></course>
            </div>
          </template>

          <pagination @paginate='paginate' pagination-anchor='#results' :current-page='page' :num-of-pages='numOfPages'></pagination>

        </div>

      </div>
    </div>
    <course-modal></course-modal>
  </div>
</template>

<script>
  import _ from 'lodash';
  import Course from './Course.vue';
  import CourseModal from './CourseModal.vue';
  import Pagination from './Pagination.vue';
  import SearchFilter from './SearchFilter.vue';
  import Icon from './Icon.vue';
  import qs from 'qs';
  import Loading from "vue-loading-overlay";
  import 'vue-loading-overlay/dist/vue-loading.css';

  export default {
    props: {
      recordsPerPage: {
        type: Number,
        default: 25
      },
      category: {
        type: String,
        default: ''
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
      }
    },
    components: {
      course: Course,
      searchFilter: SearchFilter,
      pagination: Pagination,
      courseModal: CourseModal,
      icon: Icon,
      loading: Loading
    },
    data () {
      return {
        params: this.paramsConstructor(null),
        isFetchingRecords: false,
        isMobile: this.isCurrentViewportMobile(),
        numOfPages: 0,
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
        this.numOfPages = parseInt(Math.ceil(nVal/this.recordsPerPage))
      },
      params: {
        handler (nVal, oVal) {
          this.fetchResults()
        },
        deep: true
      }
    },
    computed: {
      page () {
        return (parseInt(this.params.p) || 1)
      },
      isLoadable() {
        return !this.isMobile && this.isFetchingRecords;
      }
    },
    mounted () {
      this.$i18n.locale = this.locale

      let cat = {}
      if (this.category) {
        cat = { filter: { category: this.category } }
      }

      let queryParams   = qs.parse(window.location.search.replace('?', ''), { arrayFormat: 'brackets' });
      this.params       = _.merge(this.params, cat, queryParams);
      this.fetchResults()
    },
    methods: {
      isCurrentViewportMobile() {
        let w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
        return w < parseInt(window.Elements.breakpoints.lg);
      },
      changeParams (param) {
        this.params = Object.assign(this.params, param)
      },
      filter (filter) {
        this.changeParams({filter: filter, p: 1})
      },
      paginate (page) {
        this.changeParams({p: page})
      },
      clearFilters () {
        this.params = this.paramsConstructor(this.params.q);
      },
      clearFilter (filter) {
        if (filter === 'price') {
          this.params.filter.price = [0, 2500];
        } else {
          this.params.filter[filter] = [];
        }
      },
      addOptionToFilter (key, option) {
        this.params.filter[key].push(option);
      },
      removeOptionFromFilter (key, option) {
        this.params.filter[key] = this.params.filter[key].filter((e) => e !== option);
      },
      changePriceValue (value) {
        this.params.filter.price = value;
      },
      changeLowerPriceValue (value) {
        this.params.filter.price = [ value, this.params.filter.price[1] ];
      },
      paramsConstructor: function (currentQuery) {
        return Object.assign({},{
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
        });
      },
      fetchResults () {
        var vm  = this
        var stringifiedParams = qs.stringify(this.params, {indices: false, arrayFormat: 'brackets', encode: true})
        var url = `/search.json?${stringifiedParams}`
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
