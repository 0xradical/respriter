import { pgrestApi as api } from "../../config/axiosInstances";
import { update } from "../../lib/utils";
import { operations } from "../types";

const Errors = {
  EMPTY_RESPONSE: "EMPTY_RESPONSE",
  create(operation, error) {
    return new Error(`CrawlingEvent#${operation}: ${error}`);
  }
};

const state = {
  id: null,
  executionId: null
};

const mutations = {
  [operations.GET](state, payload) {
    update(state, payload);
  }
};

const actions = {
  [operations.GET](_, { providerCrawlerId }) {
    return new Promise((resolve, reject) => {
      if (!providerCrawlerId) {
        return reject(new Error("providerCrawlerId is undefined"));
      }

      api
        .get(
          `/crawling_events?provider_crawler_id=eq.${providerCrawlerId}&order=created_at.desc&limit=1`,
          {
            headers: { Prefer: "return=representation" }
          }
        )
        .then(response =>
          response?.data?.length
            ? resolve(response.data[0])
            : Promise.reject(Errors.create(operations.GET, Errors.EMPTY_RESPONSE))
        )
        .catch(error => reject(error));
    });
  }
};

export default {
  namespaced: true,
  state,
  mutations,
  actions
};
