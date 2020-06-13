import { pgrestApi as api } from "~config/axiosInstances";
import { properties as providerCrawlerProperties } from "./provider_crawler";
import { properties as providerProperties } from "./provider";
import { update } from "~utils";
import { operations } from "../types";

export const properties = ["id", "domain", "authority_confirmation_status"].join(",");

const state = {
  id: null,
  domain: null
};

const mutations = {
  [operations.GET](state, payload) {
    update(state, payload);
  }
};

const actions = {
  [operations.LIST]() {
    return new Promise((resolve, reject) => {
      api
        .get(
          `/crawler_domains?id=not.is.null&authority_confirmation_status=eq.confirmed&select=${properties},provider_crawler:provider_crawlers(${providerCrawlerProperties},provider(${providerProperties}))`,
          {
            headers: { Prefer: "return=representation" }
          }
        )
        .then(
          response => {
            const { data } = response;

            if (data?.length) {
              resolve(data.filter(d => d.id));
            } else {
              resolve([]);
            }
            resolve(response.data);
          },
          error => {
            reject(error);
          }
        );
    });
  },
  [operations.GET](_, { domain = null, filter = false } = {}) {
    return new Promise((resolve, reject) => {
      if (!domain) {
        return reject(null);
      }

      api
        .get(
          `/crawler_domains?domain=eq.${domain}&select=${properties},provider_crawler:provider_crawlers(${providerCrawlerProperties},provider(${providerProperties}))`,
          {
            headers: { Prefer: "return=representation" }
          }
        )
        .then(
          response => {
            const { data } = response;

            if (data?.length) {
              if (filter) {
                resolve(data.filter(d => d.id)[0]);
              } else {
                resolve(data[0]);
              }
            } else {
              resolve(null);
            }
          },
          error => {
            reject(error);
          }
        );
    });
  },
  [operations.CREATE](_, { domain, sessionId }) {
    return new Promise((resolve, reject) => {
      api
        .post(
          "/crawler_domains",
          {
            domain: domain
          },
          {
            headers: { Prefer: "return=representation", SessionId: sessionId }
          }
        )
        .then(
          response => {
            resolve(response.data[0]);
          },
          error => {
            reject(error);
          }
        );
    });
  }
};

export default {
  namespaced: true,
  state,
  mutations,
  actions
};
