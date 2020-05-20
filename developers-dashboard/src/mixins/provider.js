import store from "~store";
import { createNamespacedHelpers as helpers } from "vuex";
import namespaces from "~store/namespaces";
import { operations } from "~store/types";

const { mapActions: mapProviderActions } = helpers(namespaces.PROVIDER);
const { mapMutations: mapSharedMutations, mapGetters: mapSharedGetters } = helpers(
  namespaces.SHARED
);

const StoreActions = {
  $store: store,
  ...mapProviderActions({
    updateProvider: operations.UPDATE
  }),
  ...mapSharedMutations({
    updateShared: operations.UPDATE
  })
};

const StoreGetters = {
  $store: store,
  ...mapSharedGetters(["currentProvider"])
};

export default {
  data() {
    return {
      provider: {
        name: null,
        updating: false,
        error: null,
        update() {
          this.error = null;
          this.updating = true;

          StoreActions.updateProvider({
            id: StoreGetters.currentProvider()?.id,
            name: this.name
          })
            .then(provider => StoreActions.updateShared({ provider: provider }))
            .then(() => (this.name = StoreGetters.currentProvider()?.name))
            .catch(error => {
              let errorMessage;

              if (error?.response?.data) {
                // eslint-disable-next-line no-unused-vars
                const { hint, details, message } = error.response.data;
                if (hint) {
                  errorMessage = `${details}: ${hint}`;
                } else {
                  errorMessage = "name is invalid";
                }
              }

              if (errorMessage) {
                this.error = new Error(errorMessage);
              } else {
                this.error = error;
              }
            })
            .finally(() => (this.updating = false));
        }
      }
    };
  }
};
