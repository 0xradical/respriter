<template>
  <div class="el:amx-Bc_bg">
    <!-- navbar -->
    <div class="container-fluid el:amx-Bc_su">
      <navbar
        brand-class-list="el:o-navbar__slot"
        off-canvas-class-list="el:amx-D(n)@>lg"
        :slots="{ slot1: '', slot2: 'el:o-navbar__slot--stretch el:amx-Ta(r)' }"
      >
        <template #brand>
          <a :href="links['home']">
            <svg width="156px" height="40px" class="el:amx-D(n)@<sm">
              <use xlink:href="#brand-logo" />
            </svg>
            <svg width="26px" height="26px" class="el:amx-D(n)@>lg">
              <use xlink:href="#brand-logo_symbol" />
            </svg>
          </a>
        </template>

        <template #slot1>
          <!-- search goes here -->
        </template>

        <template v-slot:slot2>
          <ul
            class="el:m-list el:m-list--hrz el:amx-Fs(0.875em) el:amx-Fw(b) el:amx-Tt(u) el:amx-Mr(2em)@>lg el:amx-D(n)@<sm"
          >
            <li class="el:amx-Mr(2em)">
              <a :href="links['home']">{{ $t("dictionary.home") }}</a>
            </li>
            <li class="el:amx-Mr(2em)">
              <a :href="links['blog']">{{ $t("dictionary.blog") }}</a>
            </li>
            <li class="el:amx-Mr(2em)">
              <a :href="links['contactUs']">{{
                $t("dictionary.contact_us")
              }}</a>
            </li>
            <li class="el:amx-Mr(2em)">
              <dropdown-menu>
                <template #action>
                  <span v-for="(value, key) in visibleLocaleOption" :key="key">
                    <svg
                      width="16px"
                      height="16px"
                      class="el:amx-Mr(0.375em) el:amx-Va(m) el:amx-D(ib)"
                    >
                      <use :xlink:href="`#i18n-${key.toLowerCase()}`" />
                    </svg>
                  </span>
                </template>
                <template #menu>
                  <li
                    v-for="(value, key) in hiddenLocaleOptions"
                    class="el:amx-Mb(1.25em) el:amx-Fs(0.75em)"
                    :key="key"
                  >
                    <a href="javascript:void(0)" @click="setLocale(key)">
                      <svg
                        width="16px"
                        height="16px"
                        class="el:amx-Mr(0.25em) el:amx-Va(m) el:amx-D(ib)"
                      >
                        <use :xlink:href="`#i18n-${key.toLowerCase()}`" />
                      </svg>
                      &nbsp;
                      <span
                        style="vertical-align: middle;"
                        class="el:amx-C_fgV"
                        >{{ $i18n.i(`iso639_codes.${key}`, key)[0] }}</span
                      >
                    </a>
                  </li>
                </template>
              </dropdown-menu>
            </li>
            <li>
              <label
                data-el-theme-toggle-switch=""
                for="theme-switcher-off-canvas"
                class="el:m-theme-toggle-switch el:amx-Mr(1em)"
                style="vertical-align: middle;"
                ><input
                  type="checkbox"
                  @click="switchTheme"
                  id="theme-switcher-off-canvas" />
                <div class="el:m-theme-toggle-switch__slider"></div
              ></label>
            </li>
          </ul>
        </template>
      </navbar>
    </div>

    <div class="el:amx-Pos(r)">
      <progress-bar
        class="el:amx-Pos(a)"
        v-if="$store.state.progress_bar.loading"
        :indeterminate="true"
      />
    </div>

    <!-- HEADER / (AVATAR / SIGN OUT) -->
    <div class="el:amx-Bot el:amx-Bc_su" v-if="!loading">
      <div class="container">
        <div class="row">
          <div class="col">
            <div class="el:amx-Pt(2em) el:amx-Pb(1.125em)">
              <Header></Header>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- OFF CANVAS MENU -->
    <off-canvas-menu
      :rootClasses="[
        'el:amx-Pt(1.5em)',
        'el:amx-Pr(1.5em)',
        'el:amx-Pb(0em)',
        'el:amx-Pl(1.5em)'
      ]"
    >
      <template>
        <div
          :class="['el:o-off-canvas-menu__header-slot', 'el:amx-Bob_gray1']"
          style="height: 3.5rem;"
        >
          <div
            class="el:o-off-canvas-menu__control"
            @click="$store.commit('menu/close')"
          ></div>

          <div style="height: 32px;">
            <img
              v-if="$store.state.profile.avatarUrl != ''"
              :src="$store.state.profile.avatarUrl"
              width="32px"
              class="el:amx-D(ib)"
              style="border-radius: 50%; vertical-align: top;"
            />
            <img
              v-else
              src="../assets/avatar-default.svg"
              width="32px"
              class="el:amx-D(ib)"
              style="border-radius: 50%; vertical-align: top;"
            />
            <div class="el:amx-D(ib) el:amx-Ml(0.5em)">
              <div
                class="el:amx-Pos(r) el:amx-Fw(b) el:amx-Fs(1em)"
                style="top: -2px;"
              >
                {{ $t("user.greetings", { name: $store.state.profile.name }) }}
              </div>
              <div class="el:amx-Pos(r)" style="top: 2px;">
                <router-link
                  to="/account-settings"
                  @click.native="$store.commit('menu/close')"
                >
                  <span class="el:amx-Fs(0.875em)">{{
                    $t("dictionary.go_to_profile")
                  }}</span>
                  <svg
                    width="8px"
                    height="8px"
                    class="el:amx-D(ib) el:amx-Va(m) el:amx-Pos(r) el:amx-Ml(0.25em) el:amx-Fi_pr"
                    style="transform: rotate(-90deg);"
                  >
                    <use xlink:href="#icons-arrow-down" />
                  </svg>
                </router-link>
              </div>
            </div>
          </div>
        </div>

        <div class="el:o-off-canvas-menu__body-slot">
          <collapsible :fixed="true">
            <template #visible>
              <a :href="links['home']">{{ $t("dictionary.home") }}</a>
            </template>
          </collapsible>

          <collapsible>
            <template #visible>{{ $t("dictionary.categories") }}</template>
            <template #hidden>
              <ul class="el:m-list el:amx-Mb(1em)">
                <a
                  v-for="rootTag in $rootTags"
                  :key="rootTag.id"
                  :href="webAppURL + '/' + rootTag.id.replace(/_/g, '-')"
                >
                  <li style="padding: 4px 0px;">
                    <span
                      class="el:m-label"
                      style="height: 60px; text-align: left;"
                    >
                      <svg class="el:m-label__icon">
                        <use :xlink:href="`#tags-${rootTag.id}`" />
                      </svg>
                      <span
                        class="el:m-label__text el:amx-Ml(0.5em)"
                        style="word-break: break-word; max-width: 160px;"
                        >{{ $t(`tags.${rootTag.id}`) }}</span
                      >
                    </span>
                  </li>
                </a>
              </ul>
            </template>
          </collapsible>

          <collapsible :fixed="true">
            <template #visible>
              <a :href="links['blog']">{{ $t("dictionary.blog") }}</a>
            </template>
          </collapsible>
          <collapsible :fixed="true">
            <template #visible>
              <a :href="links['contactUs']">{{
                $t("dictionary.contact_us")
              }}</a>
            </template>
          </collapsible>

          <collapsible>
            <template #visible>
              <div v-for="(value, key) in visibleLocaleOption" :key="key">
                <a @click="setLocale(key)">
                  <svg
                    width="16px"
                    height="16px"
                    class="el:amx-Mr(0.25em) el:amx-Va(m) el:amx-D(ib)"
                  >
                    <use :xlink:href="`#i18n-${key.toLowerCase()}`" />
                  </svg>
                  <span style="vertical-align: middle;">{{
                    $t(`iso639_codes.${key}`)
                  }}</span>
                </a>
              </div>
            </template>
            <template #hidden>
              <div
                v-for="(value, key) in hiddenLocaleOptions"
                class="el:amx-Mb(1em)"
                :key="key"
              >
                <a @click="setLocale(key)" style="cursor: pointer;">
                  <svg
                    width="16px"
                    height="16px"
                    class="el:amx-Mr(0.25em) el:amx-Va(m) el:amx-D(ib)"
                  >
                    <use :xlink:href="`#i18n-${key.toLowerCase()}`" />
                  </svg>
                  <span style="vertical-align: middle;">{{
                    $t(`iso639_codes.${key}`)
                  }}</span>
                </a>
              </div>
            </template>
          </collapsible>
          <a
            :href="$session.logOutURL()"
            class="el:amx-Mt(2.5em) btn btn--primary-border btn--block"
          >
            {{ $t("dictionary.sign_out") }}
          </a>
        </div>
      </template>
    </off-canvas-menu>

    <div class="vld-parent">
      <loading
        :active.sync="loading"
        :can-cancel="false"
        :is-full-page="true"
      ></loading>
      <tabs
        v-if="!loading"
        nav-class="el:amx-Bc_su"
        :nav-borderless="true"
        content-class="el:amx-Bc_gray1"
        :size="3"
        :current-tab="currentTab"
        :active-tab-mutator="currentTab"
        :nav-containers="['container', 'row', 'col']"
        :content-containers="[
          'container',
          'row',
          'col-12 col-lg-9',
          'el:amx-Pt(1.5em) el:amx-Pb(1.5em)'
        ]"
        @onTabClick="changeTab"
      >
        <template #tab1>
          {{ $t("user.tabs.account_settings") }}
        </template>

        <template #tab2>
          {{ $t("user.tabs.interests") }}
        </template>

        <template #tab1-content>
          <router-view v-if="$route.name == 'account-settings'"></router-view>
        </template>

        <template #tab2-content>
          <router-view v-if="$route.name == 'interests'"></router-view>
        </template>
      </tabs>
    </div>
    <Footer></Footer>
  </div>
</template>

<script>
import { createNamespacedHelpers as helpers } from "vuex";
import { invert, pickBy } from "lodash";
import namespaces from "~store/namespaces";
import { operations, namespacedOperation } from "~store/types";
import { webAppDomainURL } from "~config/domains";
import { paths } from "~config/environment";
import Header from "~components/Header.vue";
import DropdownMenu from "~components/DropdownMenu.vue";
import Navbar from "~components/Navbar.vue";
import Footer from "~components/Footer.vue";
import Tabs from "~external/Tabs.vue";
import OffCanvasMenu from "~external/OffCanvasMenu.vue";
import Collapsible from "~external/Collapsible.vue";
import ProgressBar from "~external/ProgressBar.vue";

const { mapMutations: mapLocaleMutations } = helpers(namespaces.LOCALE);

const { mapMutations: mapProfileMutations } = helpers(namespaces.PROFILE);

const {
  mapMutations: mapUserAccountMutations,
  mapActions: mapUserAccountActions,
  mapState: mapUserAccountState
} = helpers(namespaces.USER_ACCOUNT);

export default {
  name: "app",

  components: {
    Header,
    Tabs,
    OffCanvasMenu,
    DropdownMenu,
    Footer,
    Collapsible,
    Navbar,
    ProgressBar
  },

  data() {
    return {
      webAppURL: "",

      localeOptions: {
        en: "hidden",
        es: "hidden",
        "pt-BR": "hidden",
        ja: "hidden"
      },

      tabs: {
        tab1: "account-settings",
        tab2: "interests"
      }
    };
  },

  created() {
    this.$store.subscribe((mutation, state) => {
      if (
        mutation.type === namespacedOperation(namespaces.LOCALE, operations.SET)
      ) {
        this.changeLocale(state.locale.code);
      }
    });

    this.setLocale(this.$route.query.locale || "en");
    this.updateUserAccount({ loading: true });
    this.initUserAccount({ userAccountId: this.$session.getUserId() })
      .then(user => {
        const profile = user?.profiles && user?.profiles[0];
        const profileUsername = profile?.username;

        if (profile && profileUsername) {
          this.initProfile(user.profiles[0]);
          return true;
        } else {
          window.location.replace(
            webAppDomainURL(
              this.$store.state.locale?.code,
              paths.noUsernamePath
            )
          );
          return false;
        }
      })
      .then(successful => this.updateUserAccount({ loading: !successful }));
  },

  computed: {
    ...mapUserAccountState(["loading", "loaded"]),

    links() {
      return {
        home: this.webAppURL,
        contactUs: `${this.webAppURL}/contact-us`,
        blog: `${this.webAppURL}/blog`
      };
    },
    hiddenLocaleOptions() {
      return pickBy(this.localeOptions, v => v == "hidden");
    },
    visibleLocaleOption() {
      return pickBy(this.localeOptions, v => v == "visible");
    },
    currentTab() {
      // eslint-disable-next-line no-undef
      return this.getTab(this.$route.name);
    }
  },

  methods: {
    ...mapLocaleMutations({
      setLocale: operations.SET
    }),
    ...mapUserAccountActions({
      initUserAccount: operations.GET
    }),
    ...mapUserAccountMutations({
      updateUserAccount: operations.UPDATE
    }),
    ...mapProfileMutations({
      initProfile: operations.GET
    }),
    getTab(name) {
      return invert(this.tabs)[name];
    },
    changeTab(tab) {
      this.$router.push({ name: this.tabs[tab] });
    },
    changeLocale(val) {
      this.$i18n.locale = val;
      this.webAppURL = this.$domains[val];
      for (let key in this.localeOptions) {
        this.localeOptions[key] = "hidden";
      }
      this.localeOptions[val] = "visible";
    },
    switchTheme() {
      const currentTheme = document.body.parentElement.dataset.theme;
      const theme = currentTheme === "light" ? "dark" : "light";

      document.body.parentElement.dataset.theme = theme;
    }
  }
};
</script>
