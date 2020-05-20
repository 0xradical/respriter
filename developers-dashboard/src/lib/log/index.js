import interval from "interval-promise";
import { secondsSinceEpoch } from "~utils";
import { logDrainApi } from "~config/axiosInstances";

export function createLog() {
  return {
    buffer: [],
    started: false,
    finishTime: undefined,
    intervalTimeout: 3000,
    maxWaitAfterFinish: 30,
    initialMessage: "Fetching logs...",
    initialPayload() {
      return {
        time: new Date().toISOString(),
        severity: "notice",
        message: {
          payload: this.initialMessage
        }
      };
    },
    poll(finishCondition, pollingCallback) {
      this.buffer = [this.initialPayload()];
      this.started = true;

      return interval(async (iteration, stop) => {
        pollingCallback();

        if (!this.finishTime && finishCondition && finishCondition()) {
          this.finishTime = secondsSinceEpoch();
        }

        if (this.mustStop()) {
          stop();
        }
      }, this.intervalTimeout);
    },
    mustStop() {
      return this.finishTime && secondsSinceEpoch() - this.finishTime > this.maxWaitAfterFinish;
    },
    set(data) {
      this.buffer = data;
    },
    reset() {
      this.buffer = [];
      this.started = false;
      this.finishTime = undefined;
    }
  };
}

export function getLog(id) {
  return new Promise(resolve => {
    if (id) {
      return logDrainApi
        .get(`/logs/${id}.json`)
        .then(response => resolve(response.data))
        .catch(() => {
          resolve([]);
        });
    } else {
      resolve([]);
    }
  });
}
