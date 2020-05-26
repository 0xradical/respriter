<template>
  <div class="row">
    <div class="col-lg-3 d-none d-lg-block">
      <div class="el:amx-Pt(1.5em) el:amx-Pb(0.5em) el:amx-Bc_su">
        <ul class="el:m-list el:m-list--unstyled">
          <li v-for="i in numOfItems" :key="i">
            <a
              href="javascript:void(0)"
              @click="selected = i"
              class="el:amx-Pl(0.875em) el:amx-Pr(0.875em)"
              :class="selected == i ? 'el:amx-Bw(2px)' : ''"
              :style="
                selected == i
                  ? 'border-left: 2px solid var(--foreground); padding-left:calc(0.875em - 2px)'
                  : ''
              "
            >
              <slot
                v-bind:selected="selected"
                v-bind:idx="i"
                :name="`side-menu-item-${i}`"
              ></slot>
            </a>
          </li>
        </ul>
      </div>
    </div>
    <div class="col-12 col-lg-9">
      <div v-for="i in numOfItems" v-show="showSection(i)" :key="i">
        <slot :name="`side-menu-item-${i}-content`"></slot>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    numOfItems: {
      type: Number,
      required: true
    }
  },

  data() {
    return {
      viewport: 0,
      facetedNavigationEnabled: false,
      selected: 1
    };
  },

  created() {
    this.viewport = this.getViewport();
    this.facetedNavigationEnabled = this.isFacetedNavigationEnabled();

    this.$nextTick(function () {
      window.addEventListener("resize", this.setViewport);
    });
  },

  watch: {
    viewport: function () {
      this.facetedNavigationEnabled = this.isFacetedNavigationEnabled();
    }
  },

  methods: {
    isFacetedNavigationEnabled() {
      return this.viewport > parseInt(window.Elements.breakpoints.lg);
    },

    getViewport() {
      return document.documentElement.clientWidth;
    },

    setViewport() {
      this.viewport = this.getViewport();
    },

    showSection(menuIdx) {
      return this.facetedNavigationEnabled ? this.selected == menuIdx : true;
    }
  }
};
</script>
