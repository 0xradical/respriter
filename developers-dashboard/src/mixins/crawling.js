import interval from "interval-promise";
import store from "~store";
import { createNamespacedHelpers as helpers } from "vuex";
import namespaces from "~store/namespaces";
import { operations } from "~store/types";
import { createLog, getLog } from "~log";

const { mapActions: mapCrawlingEventActions } = helpers(namespaces.CRAWLING_EVENT);

const { mapActions: mapProviderCrawlerActions } = helpers(namespaces.PROVIDER_CRAWLER);

const { mapMutations: mapSharedMutations, mapGetters: mapSharedGetters } = helpers(
  namespaces.SHARED
);

const StoreActions = {
  $store: store,
  ...mapCrawlingEventActions({
    getCrawlingEvent: operations.GET
  }),
  ...mapProviderCrawlerActions({
    startProviderCrawler: operations.START,
    stopProviderCrawler: operations.STOP
  }),
  ...mapSharedMutations({
    updateShared: operations.UPDATE
  })
};

const StoreGetters = {
  $store: store,
  ...mapSharedGetters(["currentProviderCrawler"])
};

const NoOp = () => {};

export default {
  data() {
    return {
      crawling: {
        id: undefined,
        data: undefined,
        starting: false,
        stopping: false,
        log: createLog(),
        intervalStopped: false,
        intervalTimeout: 5000,
        error: undefined,
        getCurrentLog() {
          getLog(this.id).then(data => this.log.set(data));
        },
        startPolling() {
          this.intervalStopped = false;

          this.poll().then(
            interval((iteration, stop) => {
              if (this.intervalStopped) {
                return Promise.resolve(stop());
              }
              return this.poll();
            }, this.intervalTimeout)
          );
        },
        stopPolling() {
          this.intervalStopped = true;
        },
        poll() {
          return StoreActions.getCrawlingEvent({
            providerCrawlerId: StoreGetters.currentProviderCrawler()?.id
          })
            .then(({ execution_id, data }) => {
              this.id = execution_id;
              this.data = data;
            })
            .catch(NoOp)
            .then(this.getCurrentLog());
        },
        start({ delay = 3000 } = {}) {
          this.error = undefined;
          this.starting = true;

          return new Promise(resolve => {
            setTimeout(resolve, delay);
          })
            .then(() =>
              StoreActions.startProviderCrawler({
                id: StoreGetters.currentProviderCrawler()?.id
              })
            )
            .then(response => {
              const {
                data: { scheduled, error }
              } = response;

              if (error == undefined && scheduled) {
                StoreActions.updateShared({
                  providerCrawler: Object.assign({}, StoreGetters.currentProviderCrawler(), {
                    scheduled: true
                  })
                });
              } else {
                throw new Error(error);
              }
            })
            .catch(error => (this.error = error))
            .finally(() => (this.starting = false));
        },
        stop({ delay = 3000 } = {}) {
          this.error = undefined;
          this.stopping = true;

          return new Promise(resolve => {
            setTimeout(resolve, delay);
          })
            .then(() =>
              StoreActions.stopProviderCrawler({
                id: StoreGetters.currentProviderCrawler()?.id
              })
            )
            .then(response => {
              const {
                data: { scheduled, error }
              } = response;

              if (error == undefined && !scheduled) {
                StoreActions.updateShared({
                  providerCrawler: Object.assign({}, StoreGetters.currentProviderCrawler(), {
                    scheduled: false
                  })
                });
              } else {
                throw new Error(error);
              }
            })
            .catch(error => (this.error = error))
            .finally(() => (this.stopping = false));
        }
      }
    };
  }
};
