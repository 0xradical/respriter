<template>
  <div>
    <client-only>
      <modal :adaptive="true" width="100%" height="100%" name="mobileFilter">
        <div class="filter-nav--mobile">
          <div class="d-f jc-sb" style="height: 15%;">
            <h5>{{ $t("dictionary.filters") }}</h5>
            <a href="#" @click="hideMobileFilter">
              <icon
                width="1em"
                height="1em"
                name="close"
                class="c1 fs16"
              ></icon>
            </a>
          </div>
          <div style="height: 85%;">
            <search-filter
              :aggregations="$store.state.meta.aggregations"
              :total="$store.state.meta.total"
              :filter="params.filter"
              :hiddenFields="hiddenFields"
              :mobileUx="true"
              @showResultsClicked="hideMobileFilter"
              @clearFiltersClicked="clearFilters"
              @optionAddedToFilter="addOptionToFilter"
              @optionRemovedFromFilter="removeOptionFromFilter"
              @priceValueChanged="changePriceValue"
            >
            </search-filter>
          </div>
        </div>
      </modal>
    </client-only>

    <div class="container pB64">
      <div class="row">
        <div class="d-n@<sm col-lg-3">
          <span class="d-ib fs14 lh1 pA20"></span>
        </div>
        <div class="col-12 col-lg-9">
          <span class="d-ib w100 fs14 lh1 pV20">
            {{
              $t("dictionary.search_results", {
                total: $store.state.meta.total
              })
            }}

            <template v-if="params.q">
              {{ $t("dictionary.for") }}
              <span class="fw-b c-fg">{{ this.params.q }}</span>
            </template>
          </span>

          <div class="d-f jc-sb ai-c">
            <div>
              <pagination
                @paginate="paginate"
                pagination-anchor="#body-anchor"
                :records-per-page="$store.state.meta.per_page"
                :current-page="$store.state.meta.page"
                :num-of-pages="$store.state.meta.pages"
              ></pagination>
            </div>
            <div class="d-n@<sm d-f ai-c sort">
              <span class="d-b fw-b mR16 sort__label">{{
                $t("dictionary.sort_by")
              }}</span>
              <multiselect
                :value="orderCurrentOption"
                @select="sortByChanged"
                track-by="key"
                label="i18n_key"
                :custom-label="
                  ({ i18n_key }) => {
                    return $t(`dictionary.${i18n_key}`);
                  }
                "
                select-label=""
                selected-label=""
                deselect-label=""
                :show-pointer="true"
                @open="orderOptionsToggled = true"
                @close="orderOptionsToggled = false"
                :options="orderOptions"
                :searchable="false"
                :allow-empty="false"
              >
                <template slot="caret" slot-scope="{ toggle }">
                  <div
                    @mousedown.prevent.stop="orderOptionsToggle(toggle)"
                    class="sort__caret"
                  >
                    <icon
                      width="1em"
                      height="1em"
                      :transform="`rotate(${orderOptionsToggled ? 180 : 0}deg)`"
                      name="arrow-down"
                      class="c1 fs16"
                    ></icon>
                  </div>
                </template>
              </multiselect>
            </div>
          </div>
        </div>
      </div>

      <div class="row mT16@>lg mB32">
        <div class="d-n@<sm col-lg-3">
          <div class="filter-nav">
            <div class="d-f jc-sb">
              <h4>{{ $t("dictionary.filters") }}</h4>
              <a
                href="#"
                class="c-err fw-b fs10"
                @click.prevent="clearFilters"
                style="margin: auto 0; text-align: right;"
              >
                {{ $t("dictionary.clear_all_filters") }}
              </a>
            </div>
            <search-filter
              :aggregations="$store.state.meta.aggregations"
              :filter="params.filter"
              :hiddenFields="hiddenFields"
              @clearFilterClicked="clearFilter"
              @optionAddedToFilter="addOptionToFilter"
              @optionRemovedFromFilter="removeOptionFromFilter"
              @priceValueChanged="changePriceValue"
            >
            </search-filter>
          </div>
        </div>

        <div class="col-12 d-n@>lg mB16">
          <hr />
          <div class="d-f jc-sb ai-c">
            <span class="fw-b">
              <span class="d-ib mR4">{{ $t("dictionary.sort_by") }}</span>
              <div class="el:m-select d-ib">
                <select
                  :value="orderCurrentOption.key"
                  class="fs12"
                  style="width: 130px;"
                  @change="sortByChanged({ key: $event.target.value })"
                >
                  <option
                    v-for="option in orderOptions"
                    :key="option.key"
                    :value="option.key"
                  >
                    {{ $t(`dictionary.${option.i18n_key}`) }}
                  </option>
                </select>
              </div>
            </span>
            <a class="c1 fw-b ws-n" href="#" @click="showMobileFilter">
              {{ $t("dictionary.filter_results") }}
            </a>
          </div>
        </div>

        <div id="results" class="col-12 col-lg-9 vld-parent">
          <loading
            :active.sync="isLoadable"
            :is-full-page="true"
            color="#4C636F"
          ></loading>
          <course-list :tag="tag" :courses="$store.state.data"></course-list>
          <pagination
            @paginate="paginate"
            pagination-anchor="#results"
            :records-per-page="$store.state.meta.per_page"
            :current-page="$store.state.meta.page"
            :num-of-pages="$store.state.meta.pages"
          ></pagination>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import _ from "lodash";
  import CourseList from "./CourseList.vue";
  import Pagination from "./Pagination.vue";
  import SearchFilter from "./SearchFilter.vue";
  import Multiselect from "./Multiselect.vue";
  import Icon from "components/Icon.vue";
  import qs from "qs";
  import Loading from "vue-loading-overlay";

  export default {
    props: {
      locale: {
        type: String,
        default: "en"
      },

      tag: {
        type: String,
        default: undefined
      },

      provider: {
        type: String,
        default: undefined
      },

      searchEndpoint: {
        type: String,
        default: "search.json"
      }
    },
    components: {
      courseList: CourseList,
      searchFilter: SearchFilter,
      pagination: Pagination,
      icon: Icon,
      loading: Loading,
      Multiselect
    },
    data() {
      return {
        params: this.defaultParams(null),
        isFetchingRecords: false,
        mobileFilterHidden: true,
        isMobile: false,
        orderCurrentOption: this.orderOptionByKey("rel"),
        orderOptionsToggled: false,
        orderOptionsToggle: function (callback) {
          this.orderOptionsToggled = !this.orderOptionsToggled;
          callback();
        }
      };
    },
    computed: {
      page() {
        return parseInt(this.params.p) || 1;
      },
      isLoadable() {
        return (
          (!this.isMobile || (this.isMobile && this.mobileFilterHidden)) &&
          this.isFetchingRecords
        );
      },
      orderOptions() {
        return this.$classpert.orderOptions;
      },
      tagParams() {
        if (this.tag) {
          return { tag: this.tag };
        } else {
          return {};
        }
      },
      hiddenFields() {
        const fields = [];

        if (this.provider) {
          return [...fields, "provider_name"];
        }

        return fields;
      }
    },
    beforeCreate() {
      this.$classpert.orderOptions = [
        { key: "rel", value: {}, i18n_key: "relevance" },
        { key: "price.asc", value: { price: "asc" }, i18n_key: "lowest_price" },
        {
          key: "price.desc",
          value: { price: "desc" },
          i18n_key: "highest_price"
        }
      ];
    },
    created() {
      this.isMobile = this.isCurrentViewportMobile();
    },
    mounted() {
      this.$i18n.locale = this.locale;

      let queryParams = qs.parse(window.location.search.replace("?", ""), {
        arrayFormat: "brackets"
      });

      if (_.get(queryParams, "filter.price")) {
        queryParams.filter.price = queryParams.filter.price.map(parseFloat);
      }

      if (_.get(queryParams, "p")) {
        queryParams.p = parseInt(queryParams.p);
      }

      if (_.get(queryParams, "order")) {
        this.orderCurrentOption =
          this.orderOptionByValue(_.get(queryParams, "order")) ||
          this.orderOptionByKey("rel");
      }

      this.params = _.merge(this.params, queryParams);

      // only start watching params after initial setup during mount
      // otherwise will double trigger record fetching
      this.$watch(
        "params",
        function (nVal, oVal) {
          if (!_.isEqual(nVal, oVal)) {
            this.fetchResults();
          }
        },
        { deep: true }
      );
    },
    methods: {
      // Check for document to be SSR friendly
      isCurrentViewportMobile() {
        if (typeof document === "undefined") {
          return false;
        } else {
          let w = Math.max(
            document.documentElement.clientWidth,
            window.innerWidth || 0
          );
          return w < 992;
        }
      },
      showMobileFilter() {
        this.mobileFilterHidden = false;
        this.$modal.show("mobileFilter");
      },
      hideMobileFilter() {
        this.mobileFilterHidden = true;
        this.$modal.hide("mobileFilter");
      },
      orderOptionByKey(key) {
        return _.find(this.$classpert.orderOptions, o => {
          return o.key === key;
        });
      },
      orderOptionByValue(value) {
        return _.find(this.$classpert.orderOptions, o => {
          return _.isEqual(o.value, value);
        });
      },
      paginate(page) {
        this.params = this.changeFilters([
          {
            filter: "p",
            value: parseInt(page || 1)
          }
        ]);
      },
      clearFilters() {
        this.params = this.defaultParams(this.params.q);
      },
      clearFilter(filter) {
        if (filter === "price") {
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
      addOptionToFilter(key, option) {
        this.params = this.changeFilters([
          {
            filter: `filter.${key}`,
            value: _.concat(this.params.filter[key], [option])
          }
        ]);
      },
      removeOptionFromFilter(key, option) {
        this.params = this.changeFilters([
          {
            filter: `filter.${key}`,
            value: _.without(this.params.filter[key], option)
          }
        ]);
      },
      changePriceValue(value) {
        this.params = this.changeFilters([
          {
            filter: "filter.price",
            value: value
          }
        ]);

        return this.params;
      },
      changeFilters(filters) {
        // go back to first page when filtering
        filters.unshift({ filter: "p", value: 1 });
        return filters.reduce(
          (acc, { filter, value }) => _.set(acc, filter, value),
          _.cloneDeep(this.params)
        );
      },
      sortByChanged({ key }) {
        let orderOption = this.orderOptionByKey(key);
        this.orderCurrentOption = orderOption;
        this.params = this.changeFilters([
          {
            filter: "order",
            value: orderOption.value
          }
        ]);
      },
      defaultParams: function (currentQuery) {
        return {
          order: {},
          filter: {
            ...(this.provider ? {} : { provider_name: [] }),
            root_audio: [],
            subtitles: [],
            price: [0, 2500]
          },
          p: 1,
          q: currentQuery
        };
      },
      fetchResults() {
        var vm = this;

        const stringifiedParams = qs.stringify(
          _.merge(this.params, this.tagParams),
          {
            indices: false,
            arrayFormat: "brackets",
            encode: true
          }
        );
        const url = `${this.searchEndpoint}?${stringifiedParams}`;
        window.history.replaceState({}, "foo", url.replace(".json", ""));

        vm.isFetchingRecords = true;
        fetch(url, { method: "GET" }).then(function (resp) {
          resp.json().then(function (json) {
            vm.$store.commit("setData", json);
            vm.isFetchingRecords = false;
          });
        });
      }
    }
  };
</script>

<style scoped lang="scss">
  hr {
    margin-bottom: 1em;
    border: none;
    border-top: 1px solid var(--foreground-low);
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
        transition: transform 0.2s ease;
      }
    }
  }

  .filter-nav {
    top: 50;
    background-color: var(--surface);
    padding: 1.5em;
  }

  .filter-nav--mobile {
    padding: 1.25em;
    height: calc(100% - 2 * 1.25em);
    box-sizing: content-box;
  }
</style>
