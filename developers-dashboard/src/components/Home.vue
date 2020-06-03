<template>
  <elements class="el:amx-Pos(r)" style="height: 100vh;">
    <div class="el:amx-Bc_su" v-if="!$route.meta.hideNavigation">
      <div class="container-fluid">
        <div class="row">
          <div class="col-12">
            <navbar
              container-class-list="el:amx-Fs(0.875em)"
              :slots="{
                slot1: 'el:amx-Pl(1em)',
                slot2: 'el:o-navbar__slot--stretch el:amx-Ta(r)'
              }"
              :off-canvas-button="false"
            >
              <template #brand>
                <svg style="width: 20px; height: 20px;">
                  <use xlink:href="#brand-logo_symbol" />
                </svg>
                <sup style="top: -1em;" class="el:amx-Ml(0.5em)">beta</sup>
              </template>

              <template #slot1>
                <span class="separator"></span>
                <div v-if="domains.length > 0" class="el:amx-Ml(1em) el:amx-Mr(2em)">
                  <div class="el:amx-Ml(1em) el:amx-D(ib) el:amx-Va(m)">
                    <div v-if="domains.length === 1" style="position: relative; top: 2px;">
                      <router-link
                        :to="{
                          name: 'domain-edit',
                          params: { domain: domains[0] }
                        }"
                        >{{ domains[0] }}</router-link
                      >
                    </div>
                    <multiselect
                      v-else
                      :value="currentDomain"
                      @select="changeDomain"
                      :select-label="null"
                      selected-label=""
                      deselect-label=""
                      :show-pointer="true"
                      :options="domains"
                      :searchable="false"
                      :allow-empty="false"
                      :style="{
                        width: `${Math.max(220, maxDomainLength * 9)}px`
                      }"
                    >
                    </multiselect>
                  </div>
                </div>
              </template>

              <template #slot2>
                <router-link :to="{ name: 'domain' }">
                  <span class="el:m-label el:amx-Mr(1.5em)">
                    <svg class="el:m-label__icon el:amx-Fs(1.25em) el:amx-Mr(0.25em)">
                      <use xlink:href="#icons-plus-sign-circled" />
                    </svg>
                    <span class="el:m-label__text">
                      Add new domain
                    </span>
                  </span>
                </router-link>
                <a href="/docs">
                  <span class="el:m-label el:amx-Mr(1.5em)">
                    <svg class="el:m-label__icon el:amx-Fs(1.25em) el:amx-Mr(0.25em)">
                      <use xlink:href="#icons-paper" />
                    </svg>
                    <span class="el:m-label__text">
                      Documentation
                    </span>
                  </span>
                </a>
                <router-link :to="{ name: 'debug-tools' }">
                  <span class="el:m-label el:amx-Mr(1.5em)">
                    <svg class="el:m-label__icon el:amx-Fs(1.25em) el:amx-Mr(0.25em)">
                      <use xlink:href="#icons-bug" />
                    </svg>
                    <span class="el:m-label__text">
                      Debug Tool
                    </span>
                  </span>
                </router-link>
                <label
                  @click="switchTheme"
                  data-el-theme-toggler
                  class="el:m-switch el:m-switch--theme-toggler"
                  for="checkbox3"
                >
                  <input type="checkbox" id="checkbox3" />
                  <div class="el:m-switch__slider"></div>
                </label>
                <span class="separator"></span>
                <span style="padding: 0 1.5em;" v-if="$store.state.profile.loaded">
                  <div class="el:m-avatar el:m-avatar--circle el:m-avatar--32x32">
                    <img
                      v-if="$store.state.profile.avatarUrl"
                      :src="$store.state.profile.avatarUrl"
                    />
                    <img v-else src="../assets/avatar-default.svg" />
                  </div>
                  <div class="el:amx-D(ib) el:amx-Va(m) el:amx-Ml(0.5em)">
                    <span v-if="$store.state.profile.firstName || $store.state.profile.username">
                      Hi,
                      {{ $store.state.profile.firstName || $store.state.profile.username }}
                    </span>
                    <span v-else>
                      Hi there!
                    </span>
                  </div>
                </span>
                <span style="padding: 0 1.5em;" v-else>
                  <div class="el:m-avatar el:m-avatar--circle el:m-avatar--32x32">
                    <img src="../assets/avatar-default.svg" />
                  </div>
                  <div class="el:amx-D(ib) el:amx-Va(m) el:amx-Ml(0.5em)">
                    Hi there!
                  </div>
                </span>
                <span class="separator"></span>
                <a class="el:m-label el:amx-Ml(1.5em)" :href="$session.logOutURL()">
                  <svg class="el:m-label__icon el:amx-Fs(1.25em) el:amx-Mr(0.25em)">
                    <use xlink:href="#icons-power-off" />
                  </svg>
                  <span class="el:m-label__text">
                    Sign out
                  </span>
                </a>
              </template>
            </navbar>
          </div>
        </div>
      </div>
    </div>
    <div class="el:amx-Bot vld-parent" :style="loading ? { height: 'calc(100vh - 60px)' } : {}">
      <loading :active.sync="loading" :can-cancel="false" :is-full-page="false"></loading>
      <router-view v-if="!loading"></router-view>
    </div>
    <div
      class="el:amx-Bc_su"
      v-if="$route.meta.hideNavigation"
      style="position: fixed; bottom: 0; width: 100%;"
    >
      <div class="container-fluid">
        <div class="row">
          <div class="col-12 el:amx-D(f) el:amx-FxJc(sb) el:amx-Bot el:amx-Pt(1em) el:amx-Pb(1em)">
            <div>
              <router-link :to="{ name: 'root' }" v-if="domains.length">
                <span class="el:m-label el:amx-Mr(1.5em)">
                  <svg
                    class="el:m-label__icon el:amx-Fs(1.25em) el:amx-Mr(0.25em) el:amx-C_pr"
                    :style="{ transform: 'rotate(90deg)' }"
                  >
                    <use xlink:href="#icons-arrow-down" />
                  </svg>
                  <span class="el:m-label__text">
                    Return to Dashboard
                  </span>
                </span>
              </router-link>
            </div>
            <div>
              <svg style="width: 20px; height: 20px;">
                <use xlink:href="#brand-logo_symbol" />
              </svg>
            </div>
          </div>
        </div>
      </div>
    </div>
  </elements>
</template>
<script>
import { createNamespacedHelpers as helpers } from "vuex";
import Navbar from "~external/Navbar.vue";
import namespaces from "~store/namespaces";
import { operations } from "~store/types";
import Elements from "~components/Elements.vue";

const { mapActions: mapProfileActions } = helpers(namespaces.PROFILE);

const { mapActions: mapCrawlerDomainActions } = helpers(namespaces.CRAWLER_DOMAIN);

const {
  mapState: mapSharedState,
  mapMutations: mapSharedMutations,
  mapGetters: mapSharedGetters
} = helpers(namespaces.SHARED);

export default {
  components: {
    Elements,
    Navbar
  },
  data() {
    return {
      theme: "default"
    };
  },
  created() {
    this.updateShared({ loading: true });
    this.fetchData();
  },
  beforeRouteUpdate(to, from, next) {
    if (to.name === "root" && this.currentDomain) {
      this.goToCurrentDomain();
    } else if (to.name === "root" && this.domains.length === 0) {
      this.goToNewDomain();
    } else {
      next();
    }
  },
  computed: {
    ...mapSharedGetters(["domains", "currentDomain", "currentProviderCrawler", "currentSitemap"]),
    ...mapSharedState(["loading", "error"]),
    loading() {
      return this.$store.state.shared.loading && this.$route?.name !== "domain";
    },
    maxDomainLength() {
      if (this.$store.state.shared.domains?.length) {
        return Math.max(...this.$store.state.shared.domains.map(({ domain }) => domain.length));
      } else {
        return 0;
      }
    }
  },
  methods: {
    ...mapCrawlerDomainActions({
      getCrawlerDomain: operations.GET,
      listCrawlerDomains: operations.LIST
    }),
    ...mapSharedMutations({
      updateShared: operations.UPDATE
    }),
    ...mapProfileActions({
      getProfile: operations.GET
    }),
    goToCurrentDomain() {
      this.$router.push({
        name: "domain-edit",
        params: { domain: this.currentDomain }
      });
    },
    goToNewDomain() {
      this.$router.push({
        name: "domain"
      });
    },
    fetchData() {
      this.getProfile({ userAccountId: this.$session.getUserId() });

      this.listCrawlerDomains().then(
        domains => {
          this.updateShared({
            domain:
              this.$route.params.domain || (domains.length > 0 ? domains[0].domain : undefined),
            domains: domains,
            loading: false,
            loaded: true
          });

          if (this.$route.name === "root") {
            if (this.currentDomain) {
              this.$router.push({
                name: "domain-edit",
                params: { domain: this.currentDomain }
              });
            }

            if (domains.length === 0) {
              this.$router.push({
                name: "domain"
              });
            }
          } else if (this.$route.meta.parent === "domain") {
            if (domains.length === 0) {
              this.$router.push({
                name: "domain"
              });
            }
          }
        },
        error => {
          this.updateShared({ error: error });
        }
      );
    },
    // eslint-disable-next-line no-unused-vars
    changeDomain(selectedOption, id) {
      this.updateShared({ loading: true, loaded: false });

      this.getCrawlerDomain({ domain: selectedOption, filter: true }).then(crawlerDomain => {
        this.updateShared({
          domain: selectedOption,
          providerCrawler: crawlerDomain?.provider_crawler,
          provider: crawlerDomain?.provider_crawler?.provider,
          loaded: true,
          loading: false
        });
        this.$router.push({
          name: "domain-edit",
          params: { domain: selectedOption }
        });
      });
    },
    switchTheme() {
      const currentTheme = document.body.parentElement.dataset.theme;
      const theme = currentTheme === "light" ? "dark" : "light";

      document.body.parentElement.dataset.theme = theme;
    }
  }
};
</script>

<style lang="scss">
.vld-parent .vld-icon {
  top: -20%;
}

fieldset[disabled] .multiselect {
  pointer-events: none;
}

.multiselect__spinner {
  position: absolute;
  right: 1px;
  top: 1px;
  width: 48px;
  height: 35px;
  background: #fff;
  display: block;
}

.multiselect__spinner:before,
.multiselect__spinner:after {
  position: absolute;
  content: "";
  top: 50%;
  left: 50%;
  margin: -8px 0 0 -8px;
  width: 16px;
  height: 16px;
  border-radius: 100%;
  border-color: var(--primary) transparent transparent;
  border-style: solid;
  border-width: 2px;
  box-shadow: 0 0 0 1px transparent;
}

.multiselect__spinner:before {
  animation: spinning 2.4s cubic-bezier(0.41, 0.26, 0.2, 0.62);
  animation-iteration-count: infinite;
}

.multiselect__spinner:after {
  animation: spinning 2.4s cubic-bezier(0.51, 0.09, 0.21, 0.8);
  animation-iteration-count: infinite;
}

.multiselect__loading-enter-active,
.multiselect__loading-leave-active {
  transition: opacity 0.4s ease-in-out;
  opacity: 1;
}

.multiselect__loading-enter,
.multiselect__loading-leave-active {
  opacity: 0;
}

.multiselect,
.multiselect__input,
.multiselect__single {
  font-family: inherit;
  font-size: 16px;
  touch-action: manipulation;
}

.multiselect {
  box-sizing: content-box;
  display: block;
  position: relative;
  width: 100%;
  min-height: 40px;
  text-align: left;
  color: #35495e;
}

.multiselect * {
  box-sizing: border-box;
}

.multiselect:focus {
  outline: none;
}

.multiselect--disabled {
  background: #ededed;
  pointer-events: none;
  opacity: 0.6;
}

.multiselect--active {
  z-index: 50;
}

.multiselect--active:not(.multiselect--above) .multiselect__current,
.multiselect--active:not(.multiselect--above) .multiselect__input,
.multiselect--active:not(.multiselect--above) .multiselect__tags {
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
}

.multiselect--active .multiselect__select {
  transform: rotateZ(180deg);
}

.multiselect--above.multiselect--active .multiselect__current,
.multiselect--above.multiselect--active .multiselect__input,
.multiselect--above.multiselect--active .multiselect__tags {
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}

.multiselect__input,
.multiselect__single {
  position: relative;
  display: inline-block;
  min-height: 20px;
  line-height: 20px;
  border: none;
  border-radius: 3px;
  background: #fff;
  padding: 0 0 0 5px;
  width: calc(100%);
  transition: border 0.1s ease;
  box-sizing: border-box;
  margin-bottom: 8px;
  vertical-align: top;
}

.multiselect__input::placeholder {
  color: #35495e;
}

.multiselect__tag ~ .multiselect__input,
.multiselect__tag ~ .multiselect__single {
  width: auto;
}

.multiselect__input:hover,
.multiselect__single:hover {
  border-color: #cfcfcf;
}

.multiselect__input:focus,
.multiselect__single:focus {
  border-color: #a8a8a8;
  outline: none;
}

.multiselect__single {
  padding-left: 5px;
  margin-bottom: 8px;
  font-size: 1em;
}

.multiselect__tags-wrap {
  display: inline;
}

.multiselect__tags {
  min-height: 40px;
  display: block;
  padding: 8px 40px 0 8px;
  border-radius: 3px;
  border: 1px solid #e8e8e8;
  background: #fff;
  font-size: 14px;
}

.multiselect__tag {
  position: relative;
  display: inline-block;
  padding: 4px 26px 4px 10px;
  border-radius: 3px;
  margin-right: 10px;
  color: #fff;
  line-height: 1;
  background: var(--primary);
  margin-bottom: 5px;
  white-space: nowrap;
  overflow: hidden;
  max-width: 100%;
  text-overflow: ellipsis;
}

.multiselect__tag-icon {
  cursor: pointer;
  margin-left: 7px;
  position: absolute;
  right: 0;
  top: 0;
  bottom: 0;
  font-weight: 700;
  font-style: initial;
  width: 22px;
  text-align: center;
  line-height: 22px;
  transition: all 0.2s ease;
  border-radius: 3px;
}

.multiselect__tag-icon:after {
  content: "×";
  color: #266d4d;
  font-size: 14px;
}

.multiselect__tag-icon:focus,
.multiselect__tag-icon:hover {
  background: #369a6e;
}

.multiselect__tag-icon:focus:after,
.multiselect__tag-icon:hover:after {
  color: white;
}

.multiselect__current {
  line-height: 16px;
  min-height: 40px;
  box-sizing: border-box;
  display: block;
  overflow: hidden;
  padding: 8px 12px 0;
  padding-right: 30px;
  white-space: nowrap;
  margin: 0;
  text-decoration: none;
  border-radius: 3px;
  border: 1px solid #e8e8e8;
  cursor: pointer;
}

.multiselect__select {
  line-height: 16px;
  display: block;
  position: absolute;
  box-sizing: border-box;
  width: 40px;
  height: 38px;
  right: 1px;
  top: 1px;
  padding: 4px 8px;
  margin: 0;
  text-decoration: none;
  text-align: center;
  cursor: pointer;
  transition: transform 0.2s ease;
}

.multiselect__select:before {
  position: relative;
  right: 0;
  top: 65%;
  color: #999;
  margin-top: 4px;
  border-style: solid;
  border-width: 5px 5px 0 5px;
  border-color: #999999 transparent transparent transparent;
  content: "";
}

.multiselect__placeholder {
  color: #adadad;
  display: inline-block;
  margin-bottom: 10px;
  padding-top: 2px;
}

.multiselect--active .multiselect__placeholder {
  display: none;
}

.multiselect__content-wrapper {
  position: absolute;
  display: block;
  background: #fff;
  width: 100%;
  max-height: 240px;
  overflow: auto;
  border: 1px solid #e8e8e8;
  border-top: none;
  border-bottom-left-radius: 5px;
  border-bottom-right-radius: 5px;
  z-index: 50;
  -webkit-overflow-scrolling: touch;
}

.multiselect__content {
  list-style: none;
  display: inline-block;
  padding: 0;
  margin: 0;
  min-width: 100%;
  vertical-align: top;
}

.multiselect--above .multiselect__content-wrapper {
  bottom: 100%;
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
  border-top-left-radius: 5px;
  border-top-right-radius: 5px;
  border-bottom: none;
  border-top: 1px solid #e8e8e8;
}

.multiselect__content::webkit-scrollbar {
  display: none;
}

.multiselect__element {
  display: block;
  font-size: 0.875em;
}

.multiselect__option {
  display: block;
  padding: 12px;
  min-height: 40px;
  line-height: 16px;
  text-decoration: none;
  text-transform: none;
  position: relative;
  cursor: pointer;
  white-space: nowrap;
}

.multiselect__option:after {
  top: 0;
  right: 0;
  position: absolute;
  line-height: 40px;
  padding-right: 12px;
  padding-left: 20px;
  font-size: 13px;
}

.multiselect__option--highlight {
  color: #ffffff !important;
  background: var(--primary) !important;
  font-weight: bold !important;
}

.multiselect__option--highlight:after {
  content: attr(data-select);
  background: var(--primary);
  color: white;
}

.multiselect__option--selected {
  color: var(--foreground) !important;
  background: var(--background) !important;
  font-weight: bold !important;
}

.multiselect__option--selected:after {
  content: attr(data-selected);
  color: var(--foreground-medium) !important;
}

.multiselect__option--selected.multiselect__option--highlight {
  color: var(--foreground) !important;
  background: var(--background) !important;
  font-weight: bold !important;
}

.multiselect__option--selected.multiselect__option--highlight:after {
  color: var(--foreground-medium) !important;
  background: var(--background) !important;
  content: attr(data-selected) !important;
}

.multiselect--disabled .multiselect__current,
.multiselect--disabled .multiselect__select {
  background: #ededed;
  color: #a6a6a6;
}

.multiselect__option--disabled {
  background: #ededed !important;
  color: #a6a6a6 !important;
  cursor: text;
  pointer-events: none;
}

.multiselect__option--group {
  background: #ededed;
  color: #35495e;
}

.multiselect__option--group.multiselect__option--highlight {
  background: #35495e;
  color: #fff;
}

.multiselect__option--group.multiselect__option--highlight:after {
  background: #35495e;
}

.multiselect__option--disabled.multiselect__option--highlight {
  background: #dedede;
}

.multiselect__option--group-selected.multiselect__option--highlight {
  background: #ff6a6a;
  color: #fff;
}

.multiselect__option--group-selected.multiselect__option--highlight:after {
  background: #ff6a6a;
  content: attr(data-deselect);
  color: #fff;
}

.multiselect-enter-active,
.multiselect-leave-active {
  transition: all 0.15s ease;
}

.multiselect-enter,
.multiselect-leave-active {
  opacity: 0;
}

.multiselect__strong {
  margin-bottom: 8px;
  line-height: 20px;
  display: inline-block;
  vertical-align: top;
}

*[dir="rtl"] .multiselect {
  text-align: right;
}

*[dir="rtl"] .multiselect__select {
  right: auto;
  left: 1px;
}

*[dir="rtl"] .multiselect__tags {
  padding: 8px 8px 0px 40px;
}

*[dir="rtl"] .multiselect__content {
  text-align: right;
}

*[dir="rtl"] .multiselect__option:after {
  right: auto;
  left: 0;
}

*[dir="rtl"] .multiselect__clear {
  right: auto;
  left: 12px;
}

*[dir="rtl"] .multiselect__spinner {
  right: auto;
  left: 1px;
}

@keyframes spinning {
  from {
    transform: rotate(0);
  }
  to {
    transform: rotate(2turn);
  }
}

.separator {
  width: 1px;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.1);
  display: inline-block;
  position: absolute;
  top: 0;
  &::before {
    content: " ";
  }
}
</style>
