import { pgrestApi as api } from "~config/axiosInstances";
import { update } from "~utils";
import { operations } from "../types";

export const properties = ["id", "name", "name_dirty", "name_changed_at"].join(",");

const state = {
  id: null,
  name: null,
  nameDirty: true,
  nameChangedAt: null
};

const mutations = {
  [operations.UPDATE](state, payload) {
    update(state, payload);
  }
};

const actions = {
  // eslint-disable-next-line no-empty-pattern
  [operations.UPDATE]({}, { id, name }) {
    return new Promise((resolve, reject) => {
      api
        .patch(
          `/providers?id=eq.${id}`,
          {
            name: name
          },
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
  }
};

export default {
  namespaced: true,
  state,
  mutations,
  actions
};
