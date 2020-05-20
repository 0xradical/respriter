const axios = require("axios");
import cookieJar from "./cookieJar";
import env from "./environment";

// create api endpoints
const pgrestApi = axios.create({
  baseURL: env.pgrestApiBaseURL,
  timeout: 10000
});

const railsApi = axios.create({
  baseURL: env.railsApiBaseURL,
  timeout: 10000
});

// create public endpoints
const crossOriginXHR = axios.create({
  baseURL: env.webAppURL,
  headers: {
    "X-Requested-With": "XMLHttpRequest",
    "Content-Type": "application/json",
    "X-CSRF-TOKEN": cookieJar.get("_csrf_token"),
    Accept: "application/json"
  },
  withCredentials: true,
  timeout: 10000
});

export { pgrestApi, railsApi, crossOriginXHR };
