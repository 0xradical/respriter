<template>
  <!-- compatible with elements v9.0.0 -->
  <div :class="[...rootClassesBase, ...rootClasses]">
    <span
      :class="marginClass"
      class="tt-u ta-r"
      v-if="course.subscription_type && trialCallout && hasTrial"
    >
      <span
        class="d-ib fs8 el:m-tag el:m-tag--bold el:m-tag--primary-variant-flat"
      >
        <ssrtxt>{{
          locales.server.trialLocale || locales.client.trialLocale
        }}</ssrtxt>
        <ssrt k="dictionary.free_trial" />
      </span>
    </span>
    <div :class="marginClass" v-if="price > 0">
      <span :class="priceClasses" class="c2V fw-b">
        <span class="fs16 mR2">$ {{ formattedPrice }}</span
        ><span class="fs10" v-if="course.subscription_type"
          >/<ssrt
            :k="`dictionary.subscription_period.${course.subscription_period.unit}`"
          />
        </span>
      </span>
    </div>
    <div :class="marginClass" v-else>
      <span class="fs16 c2V fw-b tt-u">
        <ssrt k="dictionary.free" />
      </span>
    </div>
    <span class="fs10" v-if="!course.subscription_type && price > 0">
      <ssrt k="dictionary.pricing.this_course_only" />
    </span>
    <span class="el:m-label" v-if="course.subscription_type">
      <div class="d-f">
        <span
          class="el:m-label__text fs10 fw-b c-fg ta-r pR4"
          style="flex: 1 1 0%;"
          >+ <ssrt k="dictionary.pricing.all_courses" />
        </span>
        <ssrtxt class="d-n" ref="tooltipContent">{{
          locales.server.tooltipContent
        }}</ssrtxt>
        <span ref="tooltip" v-if="hasTrial">
          <icon
            :iconClasses="['el:m-label__icon', 'mT-a', 'mB-a', 'fs12', 'c-fg']"
            name="question"
            style="flex: 0 0 1.6rem;"
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
        default: "4"
      }
    },
    components: {
      Icon
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
        return ["mB" + this.spacing];
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
        return ["d-f", "fld-c", "ai-fe", "jc-c"];
      }
    }
  };
</script>
