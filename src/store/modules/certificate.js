import { pgrestApi as api } from "../../config/axiosInstances";
import { primitives } from "../types";

const state = {
  id: null,
  file: null,
  file_name: null,
  file_content_type: null,
  fetch_url: null,
  upload_url: null
};

const mutations = {
  [primitives.GET](state, payload) {
    state.id = payload.id;
    state.fetch_url = payload.fetch_url;
    state.file_content_type = payload.file_content_type;
  },
  [primitives.AUTH](state, payload) {
    state.id = payload.id;
    state.fetch_url = payload.fetch_url;
    state.upload_url = payload.upload_url;
    state.file_content_type = payload.file_content_type;
  }
};

const actions = {
  [primitives.AUTH]({ commit, state }, { file_name, user_account_id }) {
    return new Promise((resolve, reject) => {
      api
        .post(
          `/certificates`,
          {
            id: state.id,
            file: file_name,
            user_account_id: user_account_id
          },
          {
            headers: { Prefer: "return=representation" }
          }
        )
        .then(
          response => {
            commit(primitives.AUTH, response.data[0]);
            resolve({
              upload_url: state.upload_url,
              file_content_type: state.file_content_type
            });
          },
          error => {
            reject(error);
          }
        );
    });
  },
  [primitives.GET]({ commit }, { id }) {
    return new Promise((resolve, reject) => {
      api
        .get(`/certificates?id=eq.${id}`, {
          headers: { Prefer: "return=representation" }
        })
        .then(
          response => {
            commit(primitives.GET, response.data[0] || { id: id });
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
