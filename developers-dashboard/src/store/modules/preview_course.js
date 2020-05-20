import { pgrestApi as api } from "../../config/axiosInstances";
import { update } from "~utils";
import { operations } from "../types";

const state = {
  id: null,
  status: "initial",
  name: null,
  description: null,
  providerCrawlerId: null,
  providerId: null,
  previewCourseImages: [],
  indexedJson: {}
};

const mutations = {
  [operations.GET](state, payload) {
    update(state, payload);
  }
};

const actions = {
  [operations.CREATE]({ commit }, { id, providerCrawlerId: provider_crawler_id, courseUrl: url }) {
    return new Promise((resolve, reject) => {
      api
        .post(
          "/preview_courses",
          { id, provider_crawler_id, url },
          {
            headers: { Prefer: "return=representation" }
          }
        )
        .then(
          response => {
            const payload = response.data[0];
            commit(operations.GET, payload);
            resolve(payload);
          },
          error => {
            reject(error);
          }
        );
    });
  },
  [operations.GET]({ commit }, { id }) {
    return new Promise((resolve, reject) => {
      api
        .get(`/preview_courses?id=eq.${id}&select=*,preview_course_images(*)`, {
          headers: { Prefer: "return=representation" }
        })
        .then(
          response => {
            const payload = response.data[0];
            commit(operations.GET, payload);
            resolve(payload);
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
