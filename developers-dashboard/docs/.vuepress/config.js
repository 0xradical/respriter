const path = require("path");
const webpack = require("webpack");
const fence = require("./utils/markdown-it-link-within");

module.exports = {
  port: 8081,
  configureWebpack: {
    resolve: {
      alias: {
        "~components": path.resolve("docs/.vuepress/components"),
        "~external": path.resolve("src/components/external/src"),
        "~store": path.resolve("docs/.vuepress/store"),
        "~utils": path.resolve("docs/.vuepress/utils")
      }
    },
    plugins: [
      new webpack.DefinePlugin({
        ELEMENTS_URL: JSON.stringify(
          process.env.VUE_APP_ELEMENTS_HOST + "/" + process.env.VUE_APP_ELEMENTS_VERSION
        )
      })
    ]
  },
  markdown: {
    html: true
  },
  extendMarkdown: md => {
    md.renderer.rules.fence = fence;
  },
  themeConfig: {
    sidebar: [
      {
        title: "Docs",
        children: ["/docs/getting-started", "/docs/classpert-json-schema"],
        collapsable: false,
        sidebarDepth: 3
      },
      {
        title: "Troubleshooting",
        children: [
          "/docs/troubleshooting/domain-validation",
          "/docs/troubleshooting/sitemap",
          "/docs/troubleshooting/debug-tool",
          "/docs/troubleshooting/classpert-bot",
          "/docs/troubleshooting/provider-logo",
          "/docs/troubleshooting/error-codes"
        ],
        collapsable: false
      }
    ]
  },
  head: [
    [
      "link",
      {
        rel: "stylesheet",
        href: `${process.env.VUE_APP_ELEMENTS_HOST}/${process.env.VUE_APP_ELEMENTS_VERSION}/bundle.css`
      }
    ],
    [
      "link",
      {
        rel: "stylesheet",
        href: `${process.env.VUE_APP_ELEMENTS_HOST}/${process.env.VUE_APP_ELEMENTS_VERSION}/icon-font.css`
      }
    ]
  ],
  plugins: [
    "vuepress-plugin-smooth-scroll",
    [
      "@vuepress/active-header-links",
      {
        sidebarLinkSelector: ".sidebar-link",
        headerAnchorSelector: ".header-anchor"
      }
    ],
    [
      "container",
      {
        type: "el:m-table",
        before: info =>
          `<div class='el:m-table ${info || ""}'><div class='el:m-table__scrollable-content'>`,
        after: "</div></div>"
      }
    ],
    [
      "container",
      {
        type: "el:m-list",
        before: "<div class='el:m-list'>",
        after: "</div>"
      }
    ],
    [
      "container",
      {
        type: "remark-note",
        before: `<div class='el:m-remark el:m-remark--primary' data-el-remark-label='note'>`,
        after: "</div>"
      }
    ],
    [
      "container",
      {
        type: "remark-attention",
        before: `<div class='el:m-remark el:m-remark--error' data-el-remark-label='attention'>`,
        after: "</div>"
      }
    ],
    [
      "container",
      {
        type: "remark-warning",
        before: `<div class='el:m-remark el:m-remark--secondary' data-el-remark-label='warning'>`,
        after: "</div>"
      }
    ],
    [
      "container",
      {
        type: "schema-property",
        before: `<div class='schema-property'>`,
        after: `</div>`
      }
    ],
    [
      "container",
      {
        type: "schema-definition",
        before: `<div class='schema-definition'>`,
        after: `</div>`
      }
    ]
  ]
};
