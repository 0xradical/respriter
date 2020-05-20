module.exports = {
  root: true,
  env: {
    node: true,
    browser: true
  },
  extends: [
    "plugin:vue/essential",
    "eslint:recommended",
    "plugin:prettier/recommended",
    "prettier",
    "prettier/vue"
  ],
  rules: {
    "no-console": process.env.NODE_ENV === "production" ? 2 : 1,
    "no-debugger": process.env.NODE_ENV === "production" ? 2 : 1
  },
  plugins: ["import"],
  parserOptions: {
    ecmaVersion: 2020,
    parser: "babel-eslint",
    sourceType: "module"
  }
};
