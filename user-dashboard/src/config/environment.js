export const system = {
  node_env: process.env.NODE_ENV
};

export const urls = {
  appURL: process.env.VUE_APP_URL,
  webAppURL: process.env.VUE_APP_WEB_APP_URL,
  railsApiBaseURL: process.env.VUE_APP_RAILS_API_BASE_URL,
  pgrestApiBaseURL: process.env.VUE_APP_PGREST_API_BASE_URL
};

export const paths = {
  tokenAuthPath: process.env.VUE_APP_TOKEN_AUTH_PATH,
  forgotPasswordPath: process.env.VUE_APP_FORGOT_PASSWORD_PATH,
  noUsernamePath: process.env.VUE_APP_NO_USERNAME_PATH,
  logInPath: process.env.VUE_APP_LOG_IN_PATH,
  logOutPath: process.env.VUE_APP_LOG_OUT_PATH
};

export default {
  ...system,
  ...urls,
  ...paths
};
