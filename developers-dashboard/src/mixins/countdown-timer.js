export function createCountdownTimer() {
  return {
    data() {
      return {
        countdownTimer: {
          id: undefined,
          timeout: 60 * 5,
          counter: 0,
          status: "initial",
          callback: undefined
        }
      };
    },
    computed: {
      countdownTimerRemaining() {
        return this.countdownTimer.timeout - this.countdownTimer.counter;
      },
      countdownTimerLabel() {
        const minutes = parseInt(this.countdownTimerRemaining / 60, 10);
        const seconds = parseInt(this.countdownTimerRemaining % 60, 10);

        return `${minutes < 10 ? "0" + minutes : minutes}:${
          seconds < 10 ? "0" + seconds : seconds
        }`;
      }
    },
    methods: {
      countdownTimerStart(callback) {
        this.countdownTimer.status = "started";
        this.countdownTimer.callback = callback;
        this.countdownTimerTick();
      },

      countdownTimerStop() {
        this.countdownTimer.status = "stopped";
        if (this.countdownTimer.callback) {
          this.countdownTimer.callback();
        }
        this.countdownTimerClear();
      },

      countdownTimerClear(status) {
        if (this.countdownTimer.id) {
          window.clearTimeout(this.countdownTimer.id);
          this.countdownTimer.id = undefined;
        }
        this.countdownTimer.counter = 0;
        if (status) {
          this.countdownTimer.status = status;
        }
      },

      countdownTimerReset() {
        this.countdownTimerClear();
        this.countdownTimerTick();
      },

      countdownTimerTick() {
        if (this.countdownTimer.counter < this.countdownTimer.timeout) {
          this.countdownTimer.counter = this.countdownTimer.counter + 1;
          this.countdownTimerAgain();
        } else {
          this.countdownTimerStop();
        }
      },

      countdownTimerAgain() {
        this.countdownTimer.id = window.setTimeout(this.countdownTimerTick, 1000);
      }
    }
  };
}

export default createCountdownTimer();
