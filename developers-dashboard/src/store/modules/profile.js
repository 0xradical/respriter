import normalizeUrl from "normalize-url";
import { pgrestApi as api } from "../../config/axiosInstances";
import { operations } from "../types";

const state = {
  name: null,
  firstName: null,
  avatarUrl: null,
  username: null,
  interests: [],
  loaded: false
};

const mutations = {
  [operations.GET](state, payload) {
    state.name = payload.name || state.name;
    state.username = payload.username || state.username;
    state.interests = payload.interests || state.interests;
    state.avatarUrl =
      payload.avatarUrl &&
      normalizeUrl(payload.avatar_url || state.avatarUrl, {
        defaultProtocol: "https:"
      });
    if (state.name) {
      state.firstName = state.name.split(/\s+/)[0];
    }
    state.loaded = true;
  }
};

const actions = {
  [operations.GET]({ commit }, { userAccountId }) {
    return new Promise((resolve, reject) => {
      api.get(`/profiles?user_account_id=eq.${userAccountId}`).then(
        response => {
          commit(operations.GET, response.data[0]);
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
