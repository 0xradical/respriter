# Classpert's Components

House to several reusable Vue components

## External dependencies

Although the initial intent was to serve pluggable and environment
agnostic components, as development evolved, there have been inevitable
external dependencies plugged into components themselves (such as `marked`, which is a library used to generate HTML from Markdown, use in `CourseDescription`)

To remedy this situation, we import said external dependencies by using a double-tilde prefix (for example, `import "~~marked"` instead of `import "marked"`). This double-tilde prefix is meant to be overriden using `alias`
functionality from the importing project's bundler (such as `Webpack`), like so:

```js
  // ...
  resolve: {
    alias: {
      "~~marked$": require.resolve("marked") // or any other custom marked "proxy"
    }
  }
  // ...
```

This also makes components SSR-friendly, since this emulates `Nuxt.js` plugin feature. On a SSR bundler configuration, one can define a certain library to
point to a different version, like so:

```js
  // webpack.browser.config.js
  resolve: {
    alias: {
      "~~marked$": require.resolve("marked/client")
    }
  }
  // ...
```

```js
  // webpack.ssr.config.js
  resolve: {
    alias: {
      "~~marked$": require.resolve("marked/server")
    }
  }
  // ...
```

## Current external dependencies:

Here's a list of external dependencies that an importing project
is supposed to alias:

- dompurify
- marked
- tippy.js
- video-service
- lazy-hydration
- lodash

## i18n

Importing project is also expected to serve i18n functionality through singleton
function `$t` throughout components. This is usually done by creating a `vue-i18n` instance and associating with the root component, on the `i18n` option. Any i18n library used with these components must obey this minimum API requirement.
