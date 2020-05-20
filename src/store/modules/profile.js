import { pgrestApi as api } from "../../config/axiosInstances";
import normalizeUrl from "normalize-url";
import { primitives } from "../types";

const state = {
  name: "",
  avatar_url: "",
  username: "",
  interests: [],
  loaded: false
};

const mutations = {
  [primitives.GET](state, payload) {
    state.name = payload.name || state.name;
    state.username = payload.username || state.username;
    state.interests = payload.interests || state.interests;
    state.avatar_url =
      payload.avatar_url &&
      normalizeUrl(payload.avatar_url || state.avatar_url, {
        defaultProtocol: "https:"
      });
    state.loaded = true;
  },
  [primitives.UPDATE](state, payload) {
    for (const key in payload) {
      if (Object.prototype.hasOwnProperty.call(payload, key)) {
        state[key] = payload[key];
      }
    }
  }
};

const actions = {
  [primitives.GET]({ commit }, { user_account_id }) {
    return new Promise((resolve, reject) => {
      api.get(`/profiles?user_account_id=eq.${user_account_id}`).then(
        response => {
          const payload = response.data[0];

          if (payload) {
            commit(primitives.GET, payload);
          }

          resolve(response);
        },
        error => {
          reject(error);
        }
      );
    });
  },
  [primitives.UPDATE]({ commit }, { user_account_id, payload }) {
    return new Promise((resolve, reject) => {
      api
        .patch(`/profiles?user_account_id=eq.${user_account_id}`, payload)
        .then(
          response => {
            commit(primitives.UPDATE, payload);
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
