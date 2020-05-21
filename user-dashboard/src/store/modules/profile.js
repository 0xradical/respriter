import { pipe, evolve, mergeLeft, omit } from "ramda";
import { pgrestApi as api } from "~config/axiosInstances";
import { normalizeUrl, update, shallowCamelCasedKeys } from "~utils";
import { operations } from "../types";

const state = {
  name: "",
  avatarUrl: "",
  username: "",
  shortBio: "",
  longBio: "",
  instructor: false,
  public: true,
  country: "",
  socialProfiles: {},
  elearningProfiles: {},
  interests: [],
  loaded: false
};

const normalizeAvatarUrl = evolve({ avatarUrl: normalizeUrl });
const loaded = mergeLeft({ loaded: true });

const mutations = {
  [operations.GET](state, payload) {
    pipe(
      shallowCamelCasedKeys,
      normalizeAvatarUrl,
      loaded,
      mergeLeft({ country: payload.country || "" }),
      update(state)
    )(payload);
  },
  [operations.UPDATE](state, payload) {
    pipe(shallowCamelCasedKeys, normalizeAvatarUrl, update(state))(payload);
  }
};

const actions = {
  [operations.GET]({ commit }, { userAccountId }) {
    return new Promise((resolve, reject) => {
      api.get(`/profiles?user_account_id=eq.${userAccountId}`).then(
        response => {
          const payload = response.data[0];

          if (payload) {
            commit(operations.GET, payload);
          }

          resolve(response);
        },
        error => {
          reject(error);
        }
      );
    });
  },
  [operations.UPDATE]({ commit }, { userAccountId, payload }) {
    return new Promise((resolve, reject) => {
      api
        .patch(
          `/profiles?user_account_id=eq.${userAccountId}`,
          omit(["loaded"], payload)
        )
        .then(
          response => {
            commit(operations.UPDATE, payload);
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
