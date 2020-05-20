import interval from "interval-promise";
import store from "~store";
import { createNamespacedHelpers as helpers } from "vuex";
import namespaces from "~store/namespaces";
import { operations } from "~store/types";

const { mapActions: mapProviderCrawlerActions } = helpers(namespaces.PROVIDER_CRAWLER);

const { mapMutations: mapSharedMutations, mapGetters: mapSharedGetters } = helpers(
  namespaces.SHARED
);

const StoreActions = {
  $store: store,
  ...mapProviderCrawlerActions({
    getProviderCrawler: operations.GET,
    updateProviderCrawler: operations.UPDATE
  }),
  ...mapSharedMutations({
    updateShared: operations.UPDATE
  })
};

const StoreGetters = {
  $store: store,
  ...mapSharedGetters(["currentProviderCrawler"])
};

export function inlinedToArray(inlined) {
  return inlined?.split(/\n+/) || [];
}

export function arrayToInlined(array) {
  return array?.join("\n");
}

export default {
  data() {
    return {
      inlinedUrls: {
        expanded: false,
        value: undefined,
        submitting: false,
        successful: false,
        error: undefined,
        intervalTimeout: 3000,
        intervalStopped: false,
        init() {
          this.submitting = true;
          this.successful = false;
          this.intervalStopped = false;
          this.error = undefined;
        },
        stop() {
          this.finish();
          this.intervalStopped = true;
        },
        finish() {
          this.submitting = false;
        },
        loadUrls() {
          const urls = StoreGetters.currentProviderCrawler()?.urls;
          this.expanded = urls?.length > 0;
          this.value = arrayToInlined(urls);
        },
        update({ onFinish = () => {} } = {}) {
          this.init();

          return new Promise(resolve => {
            setTimeout(resolve, 3000);
          })
            .then(() => this.pollProviderCrawler())
            .then(() => this.updateProviderCrawler())
            .then(providerCrawler => this.updateSharedProviderCrawler(providerCrawler))
            .catch(error => (this.error = error))
            .finally(() => this.finish())
            .finally(() => onFinish());
        },
        getProviderCrawler() {
          return StoreActions.getProviderCrawler({
            id: StoreGetters.currentProviderCrawler()?.id
          });
        },
        updateProviderCrawler() {
          return StoreActions.updateProviderCrawler({
            id: StoreGetters.currentProviderCrawler()?.id,
            urls: inlinedToArray(this.value)
          });
        },
        updateSharedProviderCrawler(providerCrawler) {
          return new Promise(resolve => {
            StoreActions.updateShared({
              providerCrawler: providerCrawler
            });

            resolve(providerCrawler);
          });
        },
        pollProviderCrawler() {
          return interval((iteration, stop) => {
            return this.getProviderCrawler()
              .then(providerCrawler => this.updateSharedProviderCrawler(providerCrawler))
              .then(providerCrawler => {
                if (providerCrawler.status === "active") {
                  this.successful = true;
                  this.error = undefined;
                  stop();
                }

                if (this.intervalStopped) {
                  stop();
                }
              });
          }, this.intervalTimeout);
        }
      }
    };
  }
};
