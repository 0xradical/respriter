import normalizeUrl from "normalize-url";

export const system = {
  node_env: process.env.NODE_ENV,
  domainVerificationSalt: process.env.VUE_APP_DOMAIN_VERIFICATION_SALT
};

export const elements = {
  elementsHost: process.env.VUE_APP_ELEMENTS_HOST,
  elementsVersion: process.env.VUE_APP_ELEMENTS_VERSION
};

export const urls = {
  appURL: process.env.VUE_APP_URL,
  webAppURL: process.env.VUE_APP_WEB_APP_URL,
  pgrestApiBaseURL: process.env.VUE_APP_PGREST_API_BASE_URL,
  logDrainURL: process.env.VUE_APP_LOG_DRAIN_BASE_URL
};

export const endpoints = {
  videoServiceEndpoint: normalizeUrl(`${process.env.VUE_APP_WEB_APP_URL}/videos`),
  previewVideoServiceEndpoint: normalizeUrl(
    `${process.env.VUE_APP_WEB_APP_URL}/developers/preview_course_videos`
  ),
  previewCourseEndpoint: normalizeUrl(
    `${process.env.VUE_APP_WEB_APP_URL}/developers/preview_courses`
  ),
  previewCourseScreenshotEndpoint: normalizeUrl(`${process.env.VUE_APP_AWS_S3_ASSET_HOST}/unsigned`)
};

export default {
  ...system,
  ...elements,
  ...urls,
  ...endpoints
};
