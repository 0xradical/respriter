<template>
  <div>
    <div data-sprites style="width:0;height:0;overflow:hidden"></div>
    <navbar
      container-class-list="navbar el:amx-Pos(r) el:amx-Pl(0.5em) el:amx-Pr(0.5em) el:amx-Bob justify-content-center justify-content-md-normal"
      :slots="{
        slot1: 'd-none d-md-inline-block el:amx-Pl(1em)',
        slot2:
          'd-none d-md-inline-block el:o-navbar__slot--stretch el:amx-Ta(r)'
      }"
      :off-canvas-button="false"
    >
      <template #brand>
        <nav class="el:amx-Pos(a) d-md-none" style="left: 1em">
          <a
            @click="$store.commit('menu/open')"
            class="el:o-navbar__offcanvas-button"
          ></a>
        </nav>
        <svg width="164px" height="27px" class="d-none d-md-block">
          <use xlink:href="#brand-logo_developers" />
        </svg>
        <svg
          width="164px"
          height="27px"
          class="d-block d-md-none"
          style="margin-left: auto; margin-right: auto;"
        >
          <use xlink:href="#brand-logo_developers" />
        </svg>
      </template>

      <template #slot1> </template>

      <template #slot2>
        <a href="/dashboard" class="d-none d-md-inline-block el:amx-Mr(1.5em)">
          Dashboard
        </a>
        <a
          href="https://classpert.com/contact-us"
          class="d-none d-md-inline-block"
        >
          Need Help? Contact us
        </a>
      </template>
    </navbar>

    <main>
      <!-- OFF CANVAS MENU -->
      <off-canvas-menu
        id="menu"
        :left="true"
        :rootClasses="[
          'el:amx-Pt(1.5em)',
          'el:amx-Pr(1.5em)',
          'el:amx-Pb(0em)',
          'el:amx-Pl(0em)'
        ]"
      >
        <template>
          <div
            :class="['el:o-off-canvas-menu__header-slot', 'el:amx-Bob_gray1']"
            style="height:1.5rem"
          >
            <div
              class="el:o-off-canvas-menu__control"
              @click="$store.commit('menu/close')"
            ></div>
          </div>
          <div class="el:o-off-canvas-menu__body-slot">
            <SidebarLinks :depth="0" :items="sidebarItems" />
          </div>
        </template>
      </off-canvas-menu>
      <sidebar :items="sidebarItems"></sidebar>
      <div class="content el:amx-Bc_su">
        <div style="max-width:960px;">
          <Content />
        </div>
      </div>
    </main>
  </div>
</template>

<script>
import Navbar from "~external/Navbar.vue";
import OffCanvasMenu from "~external/OffCanvasMenu.vue";
import Sidebar from "~components/Sidebar.vue";
import SidebarLinks from "~components/SidebarLinks.vue";
import { resolveSidebarItems } from "~utils";

export default {
  components: {
    Navbar,
    Sidebar,
    SidebarLinks,
    OffCanvasMenu
  },

  mounted() {
    fetch(`${ELEMENTS_URL}/svgs/sprites/brand.svg`, { method: "GET" }).then(
      function(response) {
        response.text().then(function(svg) {
          document.querySelector("[data-sprites]").innerHTML = svg;
        });
      }
    );
  },

  computed: {
    sidebarItems() {
      return resolveSidebarItems(
        this.$page,
        this.$page.regularPath,
        this.$site,
        this.$localePath
      );
    }
  },
  methods: {}
};
</script>

<style lang="scss">
@import "~bootstrap/scss/functions";
@import "~bootstrap/scss/variables";
@import "../styles/variables";
@import "../styles/schema";
@import "~bootstrap/scss/mixins/breakpoints";
@import "~bootstrap/scss/utilities/display";
@import "~bootstrap/scss/utilities/flex";

body {
  background-color: white;
}

.navbar {
  position: fixed;
  z-index: 20;
  width: 100%;
  border-bottom: 1px solid #d9d9e0;
  box-sizing: border-box;
}

main {
  position: static;
  z-index: 1;
  overflow-x: hidden;
  margin-top: $header-height;
}

.content {
  position: relative;
  box-sizing: border-box;
  @media (min-width: 768px) {
    left: $sidebar-width;
    width: calc(100% - #{$sidebar-width});
  }
  width: 100%;
  padding: 1em 2em;
}

.header-anchor {
  display: none;
}

pre {
  border-radius: 3px;
}

p {
  line-height: 1.5em;
}

h1 {
  font-size: 1.5em;
  margin-top: -46px;
  padding-top: 62px;
}

h2 {
  font-size: 1.25em;
  margin-top: -46px;
  padding-top: 62px;
}

h1,
h2,
h3,
h4,
h5,
h6 {
  margin-top: -3.1rem;
  padding-top: 4.6rem;
  margin-bottom: 0;
}

.table-of-contents {
  font-size: 0.875em;

  > ul {
    margin: 0;
    padding: 0;

    > li {
      position: relative;
      margin-bottom: 1em;
      padding-left: 1em;
      list-style: none;

      &:before {
        content: "";
        display: block;
        position: absolute;
        top: 4px;
        left: -4px;
        width: 10px;
        height: 10px;
        z-index: 1;
        border-radius: 50%;
        background: #027aff;
        font-size: 0.85em;
        font-weight: 700;
      }
    }

    > li:not(:first-child) {
      &:after {
        content: "";
        position: absolute;
        height: 27px;
        width: 1px;
        left: 0;
        bottom: 9px;
        border-left: 2px solid #027aff;
      }
    }
  }

  margin-bottom: 2em;
}
</style>
<style src="../../prism-classpert.css"></style>
