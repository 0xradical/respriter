import { pgrestApi as api } from "../../config/axiosInstances";
import { update } from "../../lib/utils";
import { primitives } from "../types";

const state = {
  email: "",
  loading: false,
  loaded: false
};

const mutations = {
  [primitives.GET](state, payload) {
    update(state, payload);
  },
  [primitives.UPDATE](state, payload) {
    update(state, payload);
  }
};

const actions = {
  [primitives.GET]({ commit }, { user_account_id }) {
    return new Promise((resolve, reject) => {
      api
        .get(`/user_accounts?id=eq.${user_account_id}&select=email,profiles(*)`)
        .then(
          response => {
            const payload = response.data[0];

            if (payload) {
              commit(primitives.GET, {
                ...payload,
                loaded: true
              });
            }

            resolve(payload);
          },
          error => {
            reject(error);
          }
        );
    });
  },
  [primitives.UPDATE]({ commit }, { user_account_id, payload }) {
    return new Promise((resolve, reject) => {
      api.patch(`/user_accounts?id=eq.${user_account_id}`, payload).then(
        response => {
          commit(primitives.UPDATE, {
            ...payload,
            loaded: true
          });
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
  actions,
  mutations
};
