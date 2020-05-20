<template>
  <div class="el:amx-Pos(r)">
    <div class="el:amx-Pos(a)" style="width:100%;">
      <progress-bar
        v-if="
          domainVerification.running &&
            !domainVerification.successful &&
            countdownTimer.status !== 'stopped'
        "
        :indeterminate="true"
      />
    </div>
    <div class="container">
      <div class="row">
        <div class="col-12 offset-lg-2 col-lg-8 el:amx-Pt(3em)">
          <div
            class="el:amx-Fs(0.875em) el:amx-Mb(3em) el:amx-Mr(auto) el:amx-Ml(auto)"
            style="width:75%"
          >
            <div class="el:m-wizard-progress">
              <span class="el:m-wizard-progress__line"></span>
              <ol>
                <li :data-state="wizardStep(1)" data-label="Enter site domain"></li>
                <li :data-state="wizardStep(2)" data-label="Prove ownership"></li>
                <li :data-state="wizardStep(3)" data-label="Verify ownership"></li>
              </ol>
            </div>
          </div>
        </div>
        <div class="col-12 offset-lg-2 col-lg-8">
          <validation-observer v-slot="{ invalid }" tag="div" class="el:amx-Bot el:amx-Pt(3em)">
            <div class="el:amx-Bc_su el:amx-Mb(1.5em) el:amx-Bo">
              <div v-if="step == 1">
                <h2 class="el:amx-Fs(1.375em)">
                  Enter site domain
                </h2>
                <div class="el:amx-Mt(0.75em)">
                  First we need to know what domain we should be crawling
                </div>
                <validation-provider
                  #default="{ errors }"
                  tag="div"
                  name="domain"
                  rules="required|isValidDomain"
                  class="el:amx-Mt(3em) el:amx-D(f) el:amx-FxAi(c)"
                >
                  <div style="flex: 1">
                    <div
                      class="el:m-form-field el:amx-Mr(2em) el:amx-Pos(r)"
                      :class="[
                        (errors.length > 0 || domainUniqueness.error) && 'el:m-form-field--error'
                      ]"
                    >
                      <div
                        class="el:m-form-field__input el:m-form-field__input--medium el:m-form-field__input--block"
                      >
                        <input
                          v-model.trim="domain"
                          name="field"
                          type="text"
                          placeholder="e.g: mydomain.com"
                          @input="resetDomainCheck"
                        />
                        <svg
                          v-if="errors.length > 0 || domainUniqueness.error"
                          class="el:m-form-field__input-icon el:amx-C_er"
                          width="1.125em"
                          height="1.125em"
                          viewbox="0 0 24 24"
                        >
                          <use xlink:href="#icons-wrong" />
                        </svg>
                        <svg
                          v-if="
                            domain != null && errors.length == 0 && domainUniqueness.error == null
                          "
                          class="el:m-form-field__input-icon el:amx-Fi_pr"
                          width="1.125em"
                          height="1.125em"
                          viewbox="0 0 24 24"
                        >
                          <use xlink:href="#icons-checked" />
                        </svg>
                        <div
                          v-if="errors.length > 0 || domainUniqueness.error"
                          class="el:amx-Mt(0.25em) el:amx-C_er el:amx-Pos(a)"
                        >
                          <span class="el:amx-Fs(0.75em)">{{
                            errors.length > 0 ? errors[0] : domainUniqueness.error
                          }}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div style="flex: 0 0 160px">
                    <button
                      class="btn btn--primary-flat btn--sm"
                      @click="checkDomain().then(goForward, () => {})"
                      :disabled="
                        step == 1 &&
                          (invalid ||
                            domainUniqueness.validating ||
                            (!domainUniqueness.valid && domainUniqueness.error))
                      "
                    >
                      {{ domainUniqueness.validating ? "Confirming" : "Confirm domain" }}
                    </button>
                  </div>
                </validation-provider>
              </div>

              <div v-if="step == 2">
                <h2 class="el:amx-Fs(1.375em)">
                  Prove ownership
                </h2>
                <div class="el:amx-Mt(0.75em)">
                  Select a method to verify that <b>{{ domain }}</b> actually belongs to you
                </div>
                <tabs :size="3" current-tab="tab1" class="el:amx-Mt(2em)">
                  <template #tab1>
                    HTML Method
                  </template>

                  <template #tab2>
                    TXT Method
                  </template>

                  <template #tab3>
                    CNAME Method
                  </template>

                  <template #tab1-content>
                    <div class="el:amx-Fs(0.875em) el:amx-Mt(1.5em)">
                      <span>
                        Edit the HTML of the website running on
                        <b>{{ domain }}</b> and place the following code inside the
                      </span>
                      <pre class="el:amx-C_prV el:amx-D(ib)"><code>&lt;head&gt;</code></pre>
                      <span>
                        tag:
                      </span>
                    </div>

                    <div
                      class="html-code el:amx-Mt(1em)"
                      style="font-size:0.75em;text-align:left;position:relative;border:1px solid #eee"
                    >
                      <a
                        v-tooltip="{
                          content: 'copied',
                          offset: '2px',
                          trigger: 'manual',
                          show: clipboard.copied.htmlVerificationCode,
                          classes: ['el:amx-Fs(0.625em)']
                        }"
                        v-clipboard:copy="htmlVerificationCode"
                        v-clipboard:success="
                          () => {
                            onCopy('htmlVerificationCode');
                          }
                        "
                        style="position:absolute;top:-0.375em;right:-0.375em;background-color:#fff;line-height:0.75em"
                      >
                        <svg width="1.5em" height="1.5em">
                          <use xlink:href="#icons-clipboard" />
                        </svg>
                      </a>
                      <highlight-code lang="html">
                        {{ htmlVerificationCode }}
                      </highlight-code>
                    </div>
                  </template>

                  <template #tab2-content>
                    <p class="el:amx-Fs(0.875em) el:amx-Mt(1.5em)">
                      Create a TXT entry for your root domain
                      <b>{{ rootDomain }}</b> in your DNS:
                    </p>

                    <table class="dns-table el:amx-Fs(0.75em)" cellpadding="0" cellspacing="0">
                      <thead>
                        <th class="dns-table__header dns-table__header--type">
                          Type
                        </th>
                        <th class="dns-table__header dns-table__header--name">
                          Name
                        </th>
                        <th class="dns-table__header dns-table__header--value">
                          Value / Target / Content
                        </th>
                      </thead>
                      <tbody>
                        <tr>
                          <td class="dns-table__cell">TXT</td>
                          <td class="dns-table__cell">
                            {{ subDomain }}
                            <a
                              v-tooltip="{
                                content: 'copied',
                                offset: '2px',
                                trigger: 'manual',
                                show: clipboard.copied.domain,
                                classes: ['el:amx-Fs(0.625em)']
                              }"
                              v-clipboard:copy="subDomain"
                              v-clipboard:success="
                                () => {
                                  onCopy('domain');
                                }
                              "
                            >
                              <svg class="el:amx-Va(m)" width="1.25em" height="1.25em">
                                <use xlink:href="#icons-clipboard" />
                              </svg>
                            </a>
                          </td>
                          <td class="el:amx-Va(m) dns-table__cell">
                            classpert-site-verification={{ domainVerificationToken }}
                            <a
                              v-tooltip="{
                                content: 'copied',
                                offset: '2px',
                                trigger: 'manual',
                                show: clipboard.copied.taggedDomainVerificationToken,
                                classes: ['el:amx-Fs(0.625em)']
                              }"
                              v-clipboard:copy="
                                `classpert-site-verification=${domainVerificationToken}`
                              "
                              v-clipboard:success="
                                () => {
                                  onCopy('taggedDomainVerificationToken');
                                }
                              "
                            >
                              <svg class="el:amx-Va(m)" width="1.25em" height="1.25em">
                                <use xlink:href="#icons-clipboard" />
                              </svg>
                            </a>
                          </td>
                        </tr>
                      </tbody>
                    </table>

                    <div class="el:amx-Fs(0.625em) el:amx-P(0.75em) el:amx-Bc_bg el:amx-Mt(3em)">
                      Sometimes DNS records take a while to make their way across the Internet. If
                      we don't find the record immediately, we'll check for it periodically and when
                      we find the record we'll make you a verified owner. To maintain your
                      verification status don’t remove the record, even after verification succeeds.
                    </div>
                  </template>

                  <template #tab3-content>
                    <p class="el:amx-Fs(0.875em) el:amx-Mt(1.5em)">
                      Create a CNAME entry for your root domain
                      <b> {{ rootDomain }}</b> in your DNS:
                    </p>

                    <table class="dns-table el:amx-Fs(0.75em)" cellpadding="0" cellspacing="0">
                      <thead>
                        <th class="dns-table__header dns-table__header--type">
                          Type
                        </th>
                        <th class="dns-table__header dns-table__header--name">
                          Name
                        </th>
                        <th class="dns-table__header dns-table__header--value">
                          Value / Target / Content
                        </th>
                      </thead>
                      <tbody>
                        <tr>
                          <td class="dns-table__cell">CNAME</td>
                          <td class="dns-table__cell">
                            {{ domainVerificationToken }}
                            <a
                              class="el:amx-D(ib)"
                              v-tooltip="{
                                content: 'copied',
                                offset: '2px',
                                trigger: 'manual',
                                show: clipboard.copied.domainVerificationToken,
                                classes: ['el:amx-Fs(0.625em)']
                              }"
                              v-clipboard:copy="domainVerificationToken"
                              v-clipboard:success="
                                () => {
                                  onCopy('domainVerificationToken');
                                }
                              "
                            >
                              <svg class="el:amx-Va(m)" width="1.25em" height="1.25em">
                                <use xlink:href="#icons-clipboard" />
                              </svg>
                            </a>
                          </td>
                          <td class="el:amx-Va(m) dns-table__cell">
                            verification.classpert.com
                            <a
                              class="el:amx-D(ib)"
                              v-tooltip="{
                                content: 'copied',
                                offset: '2px',
                                trigger: 'manual',
                                show: clipboard.copied.verificationDomain,
                                classes: ['el:amx-Fs(0.625em)']
                              }"
                              v-clipboard:copy="'verification.classpert.com'"
                              v-clipboard:success="
                                () => {
                                  onCopy('verificationDomain');
                                }
                              "
                            >
                              <svg class="el:amx-Va(m)" width="1.25em" height="1.25em">
                                <use xlink:href="#icons-clipboard" />
                              </svg>
                            </a>
                          </td>
                        </tr>
                      </tbody>
                    </table>

                    <div class="el:amx-Fs(0.625em) el:amx-P(0.75em) el:amx-Bc_bg el:amx-Mt(3em)">
                      Sometimes DNS records take a while to make their way across the Internet. If
                      we don't find the record immediately, we'll check for it periodically and when
                      we find the record we'll make you a verified owner. To maintain your
                      verification status don’t remove the record, even after verification succeeds.
                    </div>
                  </template>
                </tabs>
              </div>

              <div v-if="step == 3">
                <div>
                  <h2 class="el:amx-Fs(1.375em)" v-if="!domainVerification.successful">
                    We're verifying the ownership of your domain
                  </h2>
                  <h2 class="el:amx-Fs(1.375em)" v-else>
                    <div style="display: table">
                      <svg
                        class="el:amx-Fi_pr el:amx-Mr(0.25em)"
                        style="display: table-cell; vertical-align: middle"
                        width="1.125em"
                        height="1.125em"
                        viewbox="0 0 24 24"
                      >
                        <use xlink:href="#icons-checked" />
                      </svg>
                      <span style="display: table-cell; vertical-align: middle">
                        Ownership verified
                      </span>
                    </div>
                  </h2>
                  <div
                    class="el:amx-Mt(0.75em)"
                    v-if="!domainVerification.successful && countdownTimer.status === 'started'"
                  >
                    Verifying domain ownership. This process may take a while, please wait (
                    <pre class="el:amx-D(ib) el:amx-Fs(0.875em)">{{ countdownTimerLabel }}</pre>
                    )
                  </div>
                  <div
                    class="el:amx-Mt(0.75em)"
                    v-if="!domainVerification.successful && countdownTimer.status === 'stopped'"
                  >
                    Domain verification expired, try again later
                  </div>
                  <log-output
                    :log="domainVerification.log.buffer"
                    :key="$route.fullPath"
                    class="el:amx-Mt(2em)"
                    style="min-height: 250px; max-height: 250px;"
                  ></log-output>
                </div>
              </div>
            </div>

            <button
              v-if="step === 2 && !domainVerification.running && !domainVerification.successful"
              @click="goBack"
              class="btn btn--primary-border btn--sm"
            >
              Return
            </button>
            <button
              v-if="step === 2"
              @click="goForward()"
              class="el:amx-F(r) btn btn--primary-flat btn--sm"
            >
              I've done that
            </button>
            <button
              v-if="
                step === 3 && !domainVerification.successful && countdownTimer.status === 'stopped'
              "
              @click="startOver()"
              class="btn btn--primary-flat btn--sm"
            >
              Start Over
            </button>
            <div class="el:amx-Ta(r)">
              <button
                v-if="step === 3 && domainVerification.successful"
                class="btn btn--primary-flat btn--sm"
                @click="goToDomainEdit"
              >
                Go to Dashboard
              </button>
            </div>
          </validation-observer>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers as helpers } from "vuex";
import md5 from "md5";
import psl from "psl";
import env from "~config/environment";
import { getUserId } from "~config/session";
import namespaces from "~store/namespaces";
import { operations } from "~store/types";
import { secondsSinceEpoch } from "~utils";
import { createLog } from "~log";
import LogOutput from "~components/LogOutput.vue";
import ProgressBar from "~external/ProgressBar.vue";
import Tabs from "~external/Tabs.vue";
import Mixins from "~mixins";

const { mapActions: mapCrawlerDomainActions } = helpers(namespaces.CRAWLER_DOMAIN);
const { mapActions: mapProviderCrawlerActions } = helpers(namespaces.PROVIDER_CRAWLER);

const { mapMutations: mapSharedMutations } = helpers(namespaces.SHARED);

export default {
  mixins: [Mixins.CountdownTimer],
  data() {
    return {
      step: 1,
      domain: null,
      crawlerDomain: null,
      redirectionTimeout: 3000,
      sessionId: this.$uuid(),
      clipboard: {
        copied: {
          domain: false,
          verificationDomain: false,
          htmlVerificationCode: false,
          domainVerificationToken: false,
          taggedDomainVerificationToken: false
        },
        timeout: 1500
      },
      domainUniqueness: {
        validating: false,
        valid: false,
        checking: false,
        error: null
      },
      domainVerification: {
        successful: false,
        running: false,
        interval: null,
        timeout: 3000,
        finishTime: null,
        log: createLog(),
        stop() {
          clearInterval(this.interval);
          this.interval = null;
        },
        success() {
          this.successful = true;
          this.running = false;
          clearInterval(this.interval);
          this.interval = null;
          this.finishTime = secondsSinceEpoch();
        },
        fail() {
          this.successful = false;
          this.running = false;
          clearInterval(this.interval);
          this.interval = null;
          this.finishTime = secondsSinceEpoch();
        },
        reset() {
          this.successful = false;
          this.running = false;
          clearInterval(this.interval);
          this.interval = null;
          this.finishTime = null;
          this.log.reset();
        }
      }
    };
  },
  components: {
    LogOutput,
    ProgressBar,
    Tabs
  },
  computed: {
    domainVerificationToken() {
      if (getUserId()) {
        // eslint-disable-next-line no-undef
        return md5(`${getUserId()}${env.domainVerificationSalt}`);
      } else {
        return null;
      }
    },
    htmlVerificationCode() {
      return `
            <!-- Classpert Site Verification -->
            <meta name='classpert-site-verification' content='${this.domainVerificationToken}' />
          `;
    },
    rootDomain() {
      if (this.domain) {
        return psl.parse(this.domain).domain;
      } else {
        return null;
      }
    },
    subDomain() {
      if (this.domain) {
        return psl.parse(this.domain).subdomain || "@";
      } else {
        return null;
      }
    },
    dnsName() {
      if (this.domain) {
        if (this.rootDomain === this.domain) {
          return "@";
        } else {
          return this.rootDomain;
        }
      } else {
        return null;
      }
    }
  },

  methods: {
    ...mapProviderCrawlerActions({
      listProviderCrawlers: operations.LIST,
      createProviderCrawler: operations.CREATE
    }),
    ...mapCrawlerDomainActions({
      getCrawlerDomain: operations.GET,
      createCrawlerDomain: operations.CREATE
    }),
    ...mapSharedMutations({
      updateShared: operations.UPDATE
    }),
    resetDomainCheck() {
      this.domainUniqueness.valid = false;
      this.domainUniqueness.validating = false;
      this.domainUniqueness.error = null;
    },
    checkDomain() {
      this.domainUniqueness.validating = true;

      return new Promise((resolve, reject) => {
        return this.getCrawlerDomain({ domain: this.domain }).then(
          domain => {
            if (domain) {
              if (domain.authority_confirmation_status === "confirmed") {
                this.domainUniqueness.valid = false;
                this.domainUniqueness.validating = false;
                if (domain.id) {
                  this.domainUniqueness.error = "You already have confirmed access to this domain";
                } else {
                  this.domainUniqueness.error = "Domain already taken";
                }

                reject(true);
              } else {
                // domain is unconfirmed or deleted, good to go
                this.domainUniqueness.valid = true;
                this.domainUniqueness.validating = false;
                this.domainUniqueness.error = null;
                resolve(true);
              }
            } else {
              // domain doesn't exist
              this.domainUniqueness.valid = true;
              this.domainUniqueness.validating = false;
              this.domainUniqueness.error = null;
              resolve(true);
            }
          },
          () => {
            // generic error while trying to check uniqueness
            this.domainUniqueness.valid = false;
            this.domainUniqueness.validating = false;
            this.domainUniqueness.error = "Error while checking domain";
            reject(true);
          }
        );
      });
    },

    onCopy(field) {
      this.clipboard.copied[field] = true;
      setTimeout(() => (this.clipboard.copied[field] = false), this.clipboard.timeout);
    },

    goBack() {
      this.step -= 1;
    },

    goForward() {
      this.step += 1;

      if (this.step == 3) {
        this.addDomain();
      }
    },

    startOver() {
      this.step = 1;
      this.sessionId = this.$uuid();
      this.domainVerification.reset();
      this.countdownTimerClear("initial");
    },

    goToDomainEdit() {
      this.$router.push({
        name: "domain-edit",
        params: { domain: this.crawlerDomain.domain }
      });
    },

    wizardStep(step) {
      if (this.step == step) {
        return "active";
      } else if (this.step > step) {
        return "done";
      } else {
        return "inactive";
      }
    },

    addDomain() {
      this.domainVerification.running = true;
      this.domainVerification.log.poll(() => this.domainVerification.finishTime, this.getLogData);

      // if countdown expires, finish verification immediately
      this.countdownTimerStart(() => {
        this.domainVerification.stop();
      });

      this.createCrawlerDomain({
        domain: this.domain,
        sessionId: this.sessionId
      }).then(
        crawlerDomain => {
          this.crawlerDomain = crawlerDomain;

          this.domainVerification.interval = setInterval(() => {
            this.getCrawlerDomain({ domain: crawlerDomain.domain }).then(
              ({ authority_confirmation_status, provider_crawler }) => {
                if (
                  provider_crawler &&
                  authority_confirmation_status === "confirmed" &&
                  provider_crawler.status === "active"
                ) {
                  this.domain = null;

                  this.domainVerification.success();

                  this.updateShared({
                    domain: this.crawlerDomain.domain,
                    providerCrawler: provider_crawler,
                    domains: [...this.$store.state.shared.domains, this.crawlerDomain]
                  });
                }

                if (authority_confirmation_status === "failed") {
                  this.domainVerification.fail();
                  // if verification failed, stop countdown immediately
                  this.countdownTimerStop();
                }
              },
              () => {
                this.domainVerification.fail();
                this.countdownTimerStop();
              }
            );
          }, this.domainVerification.timeout);
        },
        // eslint-disable-next-line no-unused-vars
        error => {
          this.domainVerification.fail();
          this.countdownTimerStop();
        }
      );
    },
    getLogData() {
      this.$logs
        .get("/logs/" + this.sessionId + ".json")
        .then(({ data }) => {
          if (data && data.length && this.domainVerification.log.buffer != data) {
            this.domainVerification.log.buffer = data;
          }
        })
        .catch(() => {});
    }
  }
};
</script>

<style lang="scss">
pre {
  margin: 0;
}

.dns-table {
  table-layout: fixed;
  text-align: left;
  width: 100%;
  thead {
    background-color: #eee;
  }
  .dns-table__header,
  .dns-table__cell {
    padding: 0.5em;
  }
  .dns-table__header {
    &--type {
      width: 60px;
    }

    &--name {
      width: 250px;
    }
  }

  .dns-table__cell {
    overflow: hidden;
    text-overflow: ellipsis;
  }
}

.tooltip {
  display: block !important;
  z-index: 10000;

  .tooltip-inner {
    background: black;
    color: white;
    border-radius: 3px;
    padding: 5px 10px 4px;
  }

  .tooltip-arrow {
    width: 0;
    height: 0;
    border-style: solid;
    position: absolute;
    margin: 5px;
    border-color: black;
    z-index: 1;
  }

  &[x-placement^="top"] {
    margin-bottom: 5px;

    .tooltip-arrow {
      border-width: 5px 5px 0 5px;
      border-left-color: transparent !important;
      border-right-color: transparent !important;
      border-bottom-color: transparent !important;
      bottom: -5px;
      left: calc(50% - 5px);
      margin-top: 0;
      margin-bottom: 0;
    }
  }

  &[x-placement^="bottom"] {
    margin-top: 5px;

    .tooltip-arrow {
      border-width: 0 5px 5px 5px;
      border-left-color: transparent !important;
      border-right-color: transparent !important;
      border-top-color: transparent !important;
      top: -5px;
      left: calc(50% - 5px);
      margin-top: 0;
      margin-bottom: 0;
    }
  }

  &[x-placement^="right"] {
    margin-left: 5px;

    .tooltip-arrow {
      border-width: 5px 5px 5px 0;
      border-left-color: transparent !important;
      border-top-color: transparent !important;
      border-bottom-color: transparent !important;
      left: -5px;
      top: calc(50% - 5px);
      margin-left: 0;
      margin-right: 0;
    }
  }

  &[x-placement^="left"] {
    margin-right: 5px;

    .tooltip-arrow {
      border-width: 5px 0 5px 5px;
      border-top-color: transparent !important;
      border-right-color: transparent !important;
      border-bottom-color: transparent !important;
      right: -5px;
      top: calc(50% - 5px);
      margin-left: 0;
      margin-right: 0;
    }
  }

  &.popover {
    $color: #f9f9f9;

    .popover-inner {
      background: $color;
      color: black;
      padding: 24px;
      border-radius: 5px;
      box-shadow: 0 5px 30px rgba(black, 0.1);
    }

    .popover-arrow {
      border-color: $color;
    }
  }

  &[aria-hidden="true"] {
    visibility: hidden;
    opacity: 0;
    transition: opacity 0.15s, visibility 0.15s;
  }

  &[aria-hidden="false"] {
    visibility: visible;
    opacity: 1;
    transition: opacity 0.15s;
  }
}
</style>
