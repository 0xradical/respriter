import { secondsSinceEpoch } from "~utils";
import { createLog } from "~log";

export default {
  data() {
    return {
      debugTool: {
        url: undefined,
        running: false,
        previewCourse: undefined,
        interval: undefined,
        timeout: 3000,
        error: undefined,
        ready: false,
        finishTime: undefined,
        log: createLog(),
        stop() {
          clearInterval(this.interval);
          this.interval = undefined;
        },
        reset() {
          this.running = false;
          this.previewCourse = undefined;
          this.error = undefined;
          clearInterval(this.interval);
          this.interval = undefined;
          this.ready = false;
          this.finishTime = undefined;
          this.log.reset();
        },
        success(previewCourse) {
          this.running = false;
          this.previewCourse = previewCourse;
          this.error = undefined;
          clearInterval(this.interval);
          this.interval = undefined;
          this.ready = true;
          this.finishTime = secondsSinceEpoch();
        },
        failed(previewCourse, error) {
          this.running = false;
          this.previewCourse = previewCourse;
          this.error = error || "Debugging failed";
          clearInterval(this.interval);
          this.interval = undefined;
          this.ready = false;
          this.finishTime = secondsSinceEpoch();
        }
      }
    };
  }
};
