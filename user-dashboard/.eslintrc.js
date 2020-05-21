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
    "no-debugger": process.env.NODE_ENV === "production" ? 2 : 1,
    "no-unused-vars": [
      1,
      {
        args: "after-used",
        argsIgnorePattern: "^_",
        varsIgnorePattern: "^_"
      }
    ]
  },
  plugins: ["import"],
  parserOptions: {
    ecmaVersion: 2020,
    parser: "babel-eslint",
    sourceType: "module"
  },
  overrides: [
    {
      files: [
        "**/__tests__/*.{j,t}s?(x)",
        "**/tests/unit/**/*.spec.{j,t}s?(x)",
        "src/**/*.spec.js"
      ],
      env: {
        jest: true
      }
    }
  ]
};
