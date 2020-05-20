import uuidv4 from "uuid/v4";
import interval from "interval-promise";
import store from "~store";
import { createNamespacedHelpers as helpers } from "vuex";
import namespaces from "~store/namespaces";
import { operations } from "~store/types";
import { secondsSinceEpoch } from "~utils";
import { createLog, getLog } from "~log";

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

export default {
  data() {
    return {
      sitemap: {
        id: undefined,
        validating: false,
        successful: false,
        value: undefined,
        status: "-",
        type: "unknown",
        intervalTimeout: 3000,
        intervalStopped: false,
        finishTime: undefined,
        error: undefined,
        log: createLog(),
        finish() {
          this.validating = false;
          this.finishTime = secondsSinceEpoch();
        },
        stop() {
          this.finish();
          this.intervalStopped = true;
        },
        init() {
          this.error = undefined;
          this.validating = true;
          this.successful = false;
          this.intervalStopped = false;
          this.finishTime = undefined;
          this.log.reset();
          this.id = uuidv4();
        },
        loadSitemap() {
          const currentSitemap = StoreGetters.currentProviderCrawler()?.sitemaps?.[0];

          if (currentSitemap) {
            this.id = currentSitemap.id;
            this.value = currentSitemap.url;
            this.type = currentSitemap.type;
            this.status = currentSitemap.status;

            if (this.status === "invalid") {
              this.error = new Error(
                "sitemap could not be validated (check details in the log below)"
              );
            }

            if (this.status === "unverified") {
              this.error = new Error("sitemap could not be verified");
            }

            this.getCurrentLog();
          }
        },
        update({ onFinish = () => {} } = {}) {
          this.init();
          this.log.poll(
            () => typeof this.finishTime !== "undefined",
            () => this.getCurrentLog()
          );
          this.updateProviderCrawler()
            .then(providerCrawler => this.updateSharedProviderCrawler(providerCrawler))
            .then(() => this.pollProviderCrawler())
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
            sitemapId: this.id,
            sitemapUrl: this.value
          });
        },
        updateSharedProviderCrawler(providerCrawler) {
          return new Promise(resolve => {
            StoreActions.updateShared({
              providerCrawler: providerCrawler
            });

            this.loadSitemap();

            resolve(true);
          });
        },
        pollProviderCrawler() {
          return interval((iteration, stop) => {
            return this.getProviderCrawler()
              .then(providerCrawler => this.updateSharedProviderCrawler(providerCrawler))
              .then(() => {
                if (this.status === "verified") {
                  this.successful = true;
                  this.error = undefined;
                  stop();
                }

                if (this.status === "invalid") {
                  this.successful = false;
                  stop();
                }

                if (this.intervalStopped) {
                  stop();
                }
              });
          }, this.intervalTimeout);
        },
        getCurrentLog() {
          getLog(this.id).then(data => this.log.set(data));
        }
      }
    };
  }
};
