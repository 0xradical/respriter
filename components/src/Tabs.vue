<script>
export default {
  props: {
    currentTab: {
      type: String,
      required: false,
      default() {
        return `${this.rootTabName}1`;
      }
    },

    rootTabName: {
      type: String,
      required: false,
      default: "tab"
    },

    size: {
      type: Number,
      required: true
    },

    navGroupContainers: {
      type: Array,
      default() {
        return [];
      }
    },

    navBorderless: {
      type: Boolean,
      required: false,
      default: false
    },

    navClass: {
      type: String,
      required: false
    },

    navContainers: {
      type: Array,
      required: false,
      default() {
        return [];
      }
    },

    contentClass: {
      type: String,
      required: false
    },

    contentContainers: {
      type: Array,
      required: false,
      default() {
        return [];
      }
    },

    activeTabMutator: {
      type: String,
      required: false
    }
  },

  data() {
    return {
      activeTab: this.currentTab
    };
  },

  watch: {
    activeTabMutator(newVal, oldVal) {
      if (newVal && newVal !== this.activeTab) {
        this.activeTab = newVal;
      }
    }
  },

  render(h) {
    var getTabName = i => {
      return this.$props.rootTabName + i.toString();
    };

    var createTabs = () => {
      let tabs = [];
      for (let i = 1; i <= this.$props.size; i++) {
        let tab = h(
          "a",
          {
            class: [
              "el:o-tabs__tab",
              {
                "el:o-tabs__tab--active": this.activeTab == getTabName(i)
              }
            ],
            on: {
              click: evt => {
                this.activeTab = getTabName(i);
                this.$emit("onTabClick", getTabName(i), i, evt);
              }
            }
          },
          [this.$slots[`${this.$props.rootTabName}${i}`]]
        );
        tabs.push(tab);
      }
      return tabs;
    };

    var createPages = () => {
      let pages = [];
      for (let i = 1; i <= this.$props.size; i++) {
        let page =
          this.activeTab == getTabName(i)
            ? h("div", {}, [this.$slots[`${getTabName(i)}-content`]])
            : null;
        pages.push(page);
        pages = pages.filter(el => {
          return el != null;
        });
      }
      return pages;
    };

    var wrapAround = (containers, contentCallback) => {
      if (containers && containers.length) {
        var el = h("div", { class: containers[0] }, []),
          ptr = el;

        for (let i = 1; i < containers.length; i++) {
          let child = h("div", { class: containers[i] }, []);
          ptr.children.push(child);
          ptr = child;
        }

        ptr.children = contentCallback.apply(this);
        return [el];
      } else {
        return contentCallback.apply(this);
      }
    };

    let nav = h(
      "div",
      {
        class: ["el:o-tabs__nav", this.$props.navClass, this.$props.navBorderless && "el:o-tabs__nav--borderless" ]
      },
      wrapAround(this.$props.navContainers, createTabs)
    );

    if (
      this.$props.navGroupContainers &&
      this.$props.navGroupContainers.length
    ) {
      nav = wrapAround(this.$props.navGroupContainers, () => [nav]);
    }

    let content = h(
      "div",
      {
        class: ["el:o-tabs__content", this.$props.contentClass]
      },
      wrapAround(this.$props.contentContainers, createPages)
    );

    return h("div", { class: "el:o-tabs" }, [nav, content]);
  }
};
</script>
