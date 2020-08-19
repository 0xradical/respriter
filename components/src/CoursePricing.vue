<template>
  <div :class="[...rootClassesBase, ...rootClasses]">
    <span
      :class="marginClass"
      class="el:amx-Tt(u) el:amx-Ta(r)"
      v-if="course.subscription_type && trialCallout && hasTrial"
    >
      <span
        class="el:m-tag el:m-tag--bold el:m-tag--xxs el:m-tag--primary-variant-flat el:amx-D(ib)"
      >
        <ssrtxt>{{
          locales.server.trialLocale || locales.client.trialLocale
        }}</ssrtxt>
        <ssrt k="dictionary.free_trial" />
      </span>
    </span>
    <div :class="marginClass" v-if="price > 0">
      <span :class="priceClasses" class="el:amx-C_seV el:amx-Fw(b)">
        <span class="el:amx-Fs(1em) el:amx-Mr(0.125em)"
          >$ {{ formattedPrice }}</span
        ><span class="el:amx-Fs(0.625em)" v-if="course.subscription_type"
          >/<ssrt
            :k="`dictionary.subscription_period.${course.subscription_period.unit}`"
        /></span>
      </span>
    </div>
    <div :class="marginClass" v-else>
      <span class="el:amx-Fs(1em) el:amx-C_seV el:amx-Fw(b) el:amx-Tt(u)">
        <ssrt k="dictionary.free" />
      </span>
    </div>
    <span
      class="el:amx-Fs(0.625em)"
      v-if="!course.subscription_type && price > 0"
    >
      <ssrt k="dictionary.pricing.this_course_only" />
    </span>
    <span class="el:m-label" v-if="course.subscription_type">
      <div class="el:amx-D(f)">
        <span
          class="el:m-label__text el:amx-Fs(0.625em) el:amx-Fw(b) el:amx-C_fg el:amx-Ta(r) el:amx-Pr(0.25em)"
          style="flex: 1;"
          >+ <ssrt k="dictionary.pricing.all_courses" />
        </span>
        <ssrtxt class="el:amx-D(n)" ref="tooltipContent">{{
          locales.server.tooltipContent
        }}</ssrtxt>
        <span ref="tooltip" v-if="hasTrial">
          <icon
            :iconClasses="[
              'el:m-label__icon',
              'el:amx-Mt(a)',
              'el:amx-Mb(a)',
              'el:amx-Fs(0.75em)',
              'el:amx-C_fg'
            ]"
            name="question"
            style="flex: 0 0 1em;"
          >
          </icon>
        </span>
      </div>
    </span>
  </div>
</template>

<script>
  import tippy from "~~tippy";
  import Icon from "./Icon.vue";

  export default {
    props: {
      course: {
        type: Object,
        required: true
      },
      trialCallout: {
        type: Boolean,
        default: true
      },
      rootClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      priceClasses: {
        type: Array,
        default() {
          return [];
        }
      },
      spacing: {
        type: String,
        default: "0.25em"
      }
    },
    components: {
      icon: Icon
    },
    data() {
      return {
        locales: {
          client: {},
          server: {}
        }
      };
    },
    created() {
      if (this.$isServer) {
        this.locales.server = {
          ...(this.trialLocale
            ? {
                trialLocale: this.translate(
                  this.trialLocale.key,
                  this.trialLocale.options
                )
              }
            : {}),
          freeTrial: this.translate("dictionary.free_trial")
        };

        if (this.locales.server.trialLocale) {
          this.locales.server.tooltipContent = this.translate(
            "dictionary.pricing.tooltip",
            {
              provider: this.course.provider_name,
              offer: `${this.locales.server.trialLocale} ${this.locales.server.freeTrial}`
            }
          );
        }
      }
    },
    mounted() {
      this.locales.client = {
        ...(this.trialLocale
          ? {
              trialLocale: this.translate(
                this.trialLocale.key,
                this.trialLocale.options
              )
            }
          : {}),
        freeTrial: this.translate("dictionary.free_trial")
      };

      if (this.locales.client.trialLocale) {
        this.locales.client.tooltipContent = this.translate(
          "dictionary.pricing.tooltip",
          {
            provider: this.course.provider_name,
            offer: `${this.locales.client.trialLocale} ${this.locales.client.freeTrial}`
          }
        );
      }

      this.$nextTick(function () {
        let tooltipContent = undefined;

        if (this.locales.client.tooltipContent) {
          tooltipContent = this.locales.client.tooltipContent;
        }

        if (
          !tooltipContent &&
          this.$refs.tooltipContent &&
          this.$refs.tooltipContent.$el
        ) {
          tooltipContent = this.$refs.tooltipContent.$el.innerHTML;
        }

        if (tooltipContent && this.$refs.tooltip) {
          tippy(this.$refs.tooltip, {
            content: tooltipContent,
            placement: "bottom"
          });
        }
      });
    },
    methods: {
      translate(key, options) {
        if (this.$isServer) {
          return this.$t(key, options);
        } else if (window && window.CoursePricing) {
          return this.$i18n._t(
            key,
            this.$i18n.locale,
            { [this.$i18n.locale]: window.CoursePricing.i18n.messages },
            null,
            options
          );
        } else {
          return "";
        }
      }
    },
    computed: {
      price() {
        return parseFloat(this.course.price);
      },
      marginClass() {
        return [`el:amx-Mb(${this.spacing})`];
      },
      formattedPrice() {
        return this.price.toLocaleString(this.$i18n.locale, {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        });
      },
      hasTrial() {
        return (
          this.course?.trial_period?.unit && this.course?.trial_period?.value
        );
      },
      trialLocale() {
        if (this.hasTrial) {
          const trialPeriodUnit = this.course.trial_period.unit;
          const trialPeriodValue = this.course.trial_period.value;
          const trialPeriodQty = trialPeriodValue == 1 ? "one" : "other";
          const localeKey = `datetime.adjectives.${trialPeriodUnit}.${trialPeriodQty}`;
          return {
            key: localeKey,
            options: { count: trialPeriodValue }
          };
        } else {
          return null;
        }
      },
      rootClassesBase() {
        return [
          "el:amx-D(f)",
          "el:amx-FxDi(c)",
          "el:amx-FxAi(fe)",
          "el:amx-FxJc(c)"
        ];
      }
    }
  };
</script>
