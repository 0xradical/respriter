module.exports = {
  preset: "@vue/cli-plugin-unit-jest",
  testPathIgnorePatterns: [
    "<rootDir>/node_modules/",
    "<rootDir>/dist",
    "<rootDir>/src/components/external",
    "<rootDir>/src/locales",
    "<rootDir>/src/router",
    "<rootDir>/src/vendor"
  ],
  testMatch: ["<rootDir>/src/**/*.spec.js"],
  moduleNameMapper: {
    "^~external/(.*)$": "<rootDir>/src/components/external/src/$1",
    "^~utils$": "<rootDir>/src/lib/utils/index.js",
    "^~utils/(.*)$": "<rootDir>/src/lib/utils/$1",
    "^~validations$": "<rootDir>/src/lib/validations/index.js",
    "^~validations/(.*)$": "<rootDir>/src/lib/validations/$1",
    "^~store$": "<rootDir>/src/store/index.js",
    "^~store/(.*)$": "<rootDir>/src/store/$1",
    "^~components/(.*)$": "<rootDir>/src/components/$1",
    "^~config/(.*)$": "<rootDir>/src/config/$1"
  }
};
