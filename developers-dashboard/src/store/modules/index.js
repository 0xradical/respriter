import namespaces from "../namespaces";
import crawlerDomain from "./crawler_domain";
import crawlingEvent from "./crawling_event";
import provider from "./provider";
import providerCrawler from "./provider_crawler";
import providerLogo from "./provider_logo";
import previewCourse from "./preview_course";
import profile from "./profile";
import shared from "./shared";

export default {
  [namespaces.CRAWLER_DOMAIN]: crawlerDomain,
  [namespaces.CRAWLING_EVENT]: crawlingEvent,
  [namespaces.PROVIDER]: provider,
  [namespaces.PROVIDER_CRAWLER]: providerCrawler,
  [namespaces.PROVIDER_LOGO]: providerLogo,
  [namespaces.PREVIEW_COURSE]: previewCourse,
  [namespaces.PROFILE]: profile,
  [namespaces.SHARED]: shared
};
