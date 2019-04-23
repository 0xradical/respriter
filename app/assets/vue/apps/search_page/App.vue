<template>
  <div>
    <div v-show='phoneSearchFilter'
      class='mx-D(n)@desktop mx-D(n)@tv'
      style='position:fixed;width:100%;min-height:calc(120px + 100%);z-index:1;background-color:#FFF'>

      <div class='container'>
        <search-filter :aggregations='data.meta.aggregations' @changeFilter='filter'></search-filter>
        <button class='btn' @click='phoneSearchFilter = false'>Search</button>
      </div>
    </div>

    <div class='container mx-Pb(60px)'>
      <div class='row'>
        <div class='mx-D(n)@<medium col-lg-3'>
          <span style='font-size:0.875em;display:inline-block;line-height:1.15em;padding:20px 0'></span>
        </div>
        <div class='col-12 col-lg-9'>
          <span style='display:inline-block;line-height:1em;font-size:calc(0.4em + 0.5vw);padding:20px 0;width:100%'>
            {{ $t('dictionary.search_results', { total: data.meta.total }) }}

            <template v-if='params.q'>
              {{ $t('dictionary.for') }} <span class='query-tag'>{{ this.params.q }}</span>
            </template>

            <span style='display:inline-block;float:right'>
              {{ $t('dictionary.sort_by') }}
              <select v-model='params.order.price'>
                <option value='asc'>{{ $t('dictionary.lowest_price') }}</option>
                <option value='desc'>{{ $t('dictionary.highest_price') }}</option>
              </select>
            </span>

          </span>
          <pagination @paginate='paginate' pagination-anchor='#body-anchor' :current-page='page' :num-of-pages='numOfPages'></pagination>
        </div>
      </div>

      <div class='row'>
        <div class='mx-D(n)@<medium col-lg-3'>
          <div class='filter-nav' style='background-color:#fff;width:100%;padding: 10px 0px'>
            <h5 style='padding:10px 15px;border-bottom'>{{ $t('dictionary.filters') }}</h5>
            <search-filter :aggregations='data.meta.aggregations' :filter='params.filter' @changeFilter='filter'></search-filter>
          </div>
        </div>

        <div class='col-12 col-lg-9'>
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
  import qs from 'qs';

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
      courseModal: CourseModal
    },

    data () {
      return {
        phoneSearchFilter: false,

        params: {
          order: {},
          filter: {
            providers:  [],
            categories: [],
            audio:      [],
            subtitles:  [],
            price:      []
          },
          p: 1
        },

        numOfPages: 0,
        data: {
          meta: {
            aggregations: {
              audios: {
                buckets: []
              },
              subtitles: {
                buckets: []
              },
              providers: {
                buckets: []
              },
              max_price: {
                value: undefined
              },
              categories: {
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
      }
    },

    mounted () {
      this.$i18n.locale = this.locale
      var cat = {}
      if (this.category) {
        cat = { filter: { categories: this.category } }
      }
      this.params       = _.merge(this.params, cat, qs.parse(window.location.search.replace('?', ''), { arrayFormat: 'brackets' }))
      this.fetchResults()
    },

    methods: {

      changeParams (param) {
        this.params = Object.assign(this.params, param)
      },

      filter (filter) {
        this.changeParams({filter: filter, p: 1})
      },

      paginate (page) {
        this.changeParams({p: page})
      },

      showPhoneSearchFilter () {
        document.querySelector('body').style = 'overflow-y:hidden';
        this.phoneSearchFilter = true;
      },

      hidePhoneSearchFilterFilter () {
        document.querySelector('body').style = 'overflow-y:auto';
        this.phoneSearchFilter = false;
      },

      clear () {},

      fetchResults () {
        var vm  = this
        var stringifyedParams = qs.stringify(this.params, {indices: false, arrayFormat: 'brackets', encode: false})
        var url = `/search.json?${stringifyedParams}`
        window.history.replaceState({}, 'foo', url.replace('.json', ''))
        fetch(url, { method: 'GET' }).then(function (resp) {
          resp.json().then(function (json) {
            vm.data.records = json.data;
            vm.data.meta    = json.meta;
          })
        });
      }

    }

  }
</script>

<style scoped lang='scss'>

.filter-nav {
  position: sticky;
  top: 50;
}


.query-tag {
  padding:5px 10px;
  font-size:0.9em;
  color:#fff;
  border-radius:3px;
  background-color:#4c71a5;
}

</style>
