<template>
  <div>
    <div
      class="el:amx-Pos(a) el:amx-Bor el:amx-Pt(1em)"
      :style="{
        height: '100vh',
        width: styles.sidebarWidth,
        padding: '2em 2em 0 2em'
      }"
    >
      <router-link
        :class="[
          'el:amx-D(b) el:amx-Pos(r)',
          $router.currentRoute.name === 'domain-status' ? 'el:amx-C_fg' : 'el:amx-C_fgM'
        ]"
        :to="{ name: 'domain-status', domain: currentDomain }"
      >
        <svg
          :class="[
            'el:m-label__icon el:amx-Pos(a)',
            $router.currentRoute.name === 'domain-status' ? 'el:amx-Fi_fg' : 'el:amx-Fi_fgM'
          ]"
        >
          <use xlink:href="#icons-spider" />
        </svg>
        <div class="el:amx-Ml(1.5em) el:amx-Pos(r)" style="top: -1px">
          <span class="el:amx-Fs(0.875em)">Indexing Status</span>
        </div></router-link
      >
      <router-link
        :class="[
          'el:amx-D(b) el:amx-Mt(1em) el:amx-Pos(r)',
          $router.currentRoute.name === 'domain-settings' ? 'el:amx-C_fg' : 'el:amx-C_fgM'
        ]"
        :to="{ name: 'domain-settings', domain: currentDomain }"
      >
        <svg
          :class="[
            'el:m-label__icon el:amx-Pos(a)',
            $router.currentRoute.name === 'domain-settings' ? 'el:amx-Fi_fg' : 'el:amx-Fi_fgM'
          ]"
        >
          <use xlink:href="#icons-gear" />
        </svg>
        <div class="el:amx-Ml(1.5em) el:amx-Pos(r)" style="top: -1px">
          <span class="el:amx-Fs(0.875em)">Website Settings</span>
        </div></router-link
      >
    </div>
    <div class="container" :style="{ marginLeft: styles.sidebarWidth }">
      <div class="row">
        <div class="col-10">
          <router-view />
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { createNamespacedHelpers as helpers } from "vuex";
import namespaces from "~store/namespaces";

const { mapState: mapSharedState, mapGetters: mapSharedGetters } = helpers(namespaces.SHARED);

/* eslint-disable no-undef */
export default {
  data() {
    return {
      styles: {
        sidebarWidth: "220px"
      }
    };
  },
  computed: {
    ...mapSharedGetters(["domains", "currentDomain", "currentProviderCrawler", "currentSitemap"]),
    ...mapSharedState(["loaded", "loading", "error"])
  }
};
</script>

<style lang="stylus" scoped>
a:hover {
  svg {
    fill: inherit !important;
  }
}
</style>
