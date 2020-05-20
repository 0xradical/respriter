import uuidv4 from "uuid/v4";
import { pgrestApi as api } from "~config/axiosInstances";
import { update } from "~utils";
import { operations } from "../types";

const Errors = {
  EMPTY_RESPONSE: "could not fetch response"
};

const INITIAL_STATE = {
  id: null,
  file: null,
  fileContentType: null,
  fetchUrl: null,
  uploadUrl: null
};

const state = { ...INITIAL_STATE };

const mutations = {
  [operations.AUTH](state, payload) {
    update(state, payload);
  },
  [operations.GET](state, payload) {
    update(state, payload);
  },
  [operations.RESET](state) {
    update(state, INITIAL_STATE);
  }
};

const actions = {
  [operations.AUTH](_, { fileName, providerId }) {
    return new Promise((resolve, reject) => {
      api
        .post(
          `/provider_logos`,
          {
            id: uuidv4(),
            file: fileName,
            provider_id: providerId
          },
          {
            headers: { Prefer: "return=representation" }
          }
        )
        .then(response => {
          if (response?.data?.length) {
            const data = response.data[0];

            resolve(data);
          } else {
            reject(new Error(Errors.EMPTY_RESPONSE));
          }
        })
        .catch(error => reject(error));
    });
  },
  [operations.GET]({ commit }, { providerId }) {
    return new Promise((resolve, reject) => {
      api
        .get(`/provider_logos?provider_id=eq.${providerId}`, {
          headers: { Prefer: "return=representation" }
        })
        .then(response => {
          if (response?.data?.length) {
            const data = response.data[0];
            commit(operations.GET, data);
            resolve(data);
          } else {
            resolve(null);
          }
        })
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
