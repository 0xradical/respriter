import { pgrestApi as api, crossOriginXHR as webApp } from "../../config/axiosInstances";
import { properties as providerProperties } from "./provider";
import { update } from "../../lib/utils";
import { operations } from "../types";

export const properties = [
  "id",
  "updated_at",
  "status",
  "user_account_ids",
  "scheduled",
  "sitemaps",
  "provider_id",
  "user_agent_token",
  "urls"
].join(",");

const state = {
  id: null,
  providerId: null
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
        .get(`/provider_crawlers?select=${properties},provider(${providerProperties})`, {
          headers: { Prefer: "return=representation" }
        })
        .then(
          response => {
            resolve(response);
          },
          error => {
            reject(error);
          }
        );
    });
  },
  [operations.CREATE]() {
    return new Promise((resolve, reject) => {
      api
        .post(
          "/provider_crawlers",
          {},
          {
            headers: { Prefer: "return=representation" }
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
  },
  // eslint-disable-next-line no-unused-vars
  [operations.GET](_, { id }) {
    return new Promise((resolve, reject) => {
      api
        .get(
          `/provider_crawlers?id=eq.${id}&select=${properties},provider(${providerProperties})`,
          {
            headers: { Prefer: "return=representation" }
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
  },
  // eslint-disable-next-line no-empty-pattern
  [operations.UPDATE]({}, { id, sitemapId, sitemapUrl, urls }) {
    let payload = {};

    if (sitemapId && sitemapUrl) {
      payload.sitemaps = [{ id: sitemapId, url: sitemapUrl }];
    }
    if (urls) {
      payload.urls = urls;
    }

    return new Promise((resolve, reject) => {
      api
        .patch(`/provider_crawlers?id=eq.${id}`, payload, {
          headers: { Prefer: "return=representation" }
        })
        .then(
          response => {
            resolve(response.data[0]);
          },
          error => {
            reject(error);
          }
        );
    });
  },
  // eslint-disable-next-line no-empty-pattern
  [operations.START](_, { id }) {
    return new Promise((resolve, reject) => {
      webApp.get(`/developers/provider_crawler/${id}/start`).then(
        response => {
          resolve(response);
        },
        error => {
          reject(error);
        }
      );
    });
  },
  // eslint-disable-next-line no-empty-pattern
  [operations.STOP](_, { id }) {
    return new Promise((resolve, reject) => {
      webApp.get(`/developers/provider_crawler/${id}/stop`).then(
        response => {
          resolve(response);
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
