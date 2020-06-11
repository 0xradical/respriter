import { pgrestApi as api } from "~config/axiosInstances";
import { update } from "~utils";
import { operations } from "../types";

const state = {
  email: "",
  loading: false,
  loaded: false
};

const mutations = {
  [operations.GET](state, payload) {
    update(state)(payload);
  },
  [operations.UPDATE](state, payload) {
    update(state)(payload);
  }
};

const actions = {
  [operations.GET]({ commit }, { userAccountId }) {
    return new Promise((resolve, reject) => {
      api
        .get(`/user_accounts?id=eq.${userAccountId}&select=email,autogen_email_for_oauth,profiles(*)`)
        .then(
          response => {
            const payload = response.data[0];

            if (payload) {
              commit(operations.GET, {
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
  [operations.UPDATE]({ commit }, { userAccountId, payload }) {
    return new Promise((resolve, reject) => {
      api.patch(`/user_accounts?id=eq.${userAccountId}`, payload).then(
        response => {
          commit(operations.UPDATE, {
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
