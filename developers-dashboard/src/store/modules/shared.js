import { operations } from "../types";
import { daysFromNow } from "~utils";

const state = {
  domains: [],
  currentDomain: null,
  loading: false,
  loaded: false,
  error: null
};

const mutations = {
  [operations.UPDATE](state, { domain, providerCrawler, provider, ...rest }) {
    for (const key in rest) {
      if (Object.prototype.hasOwnProperty.call(rest, key)) {
        state[key] = rest[key];
      }
    }

    if (domain && state.domains.length) {
      state.currentDomain = state.domains.filter(d => d.domain === domain)[0];
    }

    if (providerCrawler && state.currentDomain) {
      state.currentDomain = Object.assign({}, state.currentDomain, {
        provider_crawler: providerCrawler
      });
    }

    if (provider && state.currentDomain && state.currentDomain.provider_crawler) {
      state.currentDomain = Object.assign({}, state.currentDomain, {
        provider_crawler: Object.assign({}, state.currentDomain.provider_crawler, {
          provider: provider
        })
      });
    }
  }
};

const getters = {
  domains: ({ domains }) => {
    if (domains) {
      return domains.map(k => k.domain);
    } else {
      return [];
    }
  },
  domainByDomain: ({ domains }) => domain => {
    return domains.filter(d => d.domain === domain)[0];
  },
  currentDomain: ({ currentDomain }) => {
    if (currentDomain) {
      return currentDomain.domain;
    } else {
      return null;
    }
  },
  currentProviderCrawler: ({ currentDomain }) => {
    if (currentDomain) {
      return currentDomain.provider_crawler;
    } else {
      return null;
    }
  },
  currentProviderCrawlerToken: (_, getters) => {
    return getters.currentProviderCrawler?.user_agent_token;
  },
  currentProvider: (_, getters) => {
    const providerCrawler = getters.currentProviderCrawler;

    if (providerCrawler) {
      return providerCrawler.provider;
    } else {
      return null;
    }
  },
  currentProviderNameUpdatable: (_, getters) => {
    if (!getters.currentProvider) {
      return false;
    } else if (!getters.currentProvider.name) {
      return true;
    } else if (!getters.currentProvider.name_changed_at) {
      return true;
    } else if (Date.parse(getters.currentProvider.name_changed_at) < daysFromNow(5)) {
      return false;
    } else {
      return true;
    }
  },
  currentSitemap: (_, getters) => {
    const providerCrawler = getters.currentProviderCrawler;

    if (providerCrawler && providerCrawler.sitemaps.length > 0) {
      return {
        value: providerCrawler.sitemaps[0].url,
        type: providerCrawler.sitemaps[0].type,
        status: providerCrawler.sitemaps[0].status,
        error:
          providerCrawler.sitemaps[0].status === "invalid"
            ? "sitemap could not be validated (check details in the log below)"
            : undefined
      };
    } else {
      return null;
    }
  },
  currentProviderCrawlerUrls: (_, getters) => {
    const providerCrawler = getters.currentProviderCrawler;

    return providerCrawler?.urls || [];
  },
  currentProviderCrawlerReady: (_, getters) => {
    return (
      (getters.currentSitemap?.status === "verified" ||
        getters.currentProviderCrawlerUrls.length > 0) &&
      getters.currentProviderCrawler?.status == "active"
    );
  }
};

export default {
  namespaced: true,
  state,
  mutations,
  getters
};
