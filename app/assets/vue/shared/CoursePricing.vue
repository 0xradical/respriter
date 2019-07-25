<template>
  <div :class="[...rootClassesBase, ...rootClasses]">
    <span class='el:amx-Tt(u) el:amx-Mb(0.25em) el:amx-Ta(r)' v-if="course.subscription_type && trialCallout">
      <span class='el:amx-Fs(0.75em)'>
        {{ trialLocale }}
      </span>
      <span class='el:amx-C_white el:amx-Bc_green3 el:amx-Fw(b) el:amx-Pr(0.25em) el:amx-Pl(0.25em) el:amx-Pt(0.125em) el:amx-Pb(0.125em) el:amx-Fs(0.625em) el:amx-Ws(nr) el:amx-D(ib)'>
        {{ $t('dictionary.free_trial') }}
      </span>
    </span>
    <div class='el:amx-Mb(0.25em)' v-if="price > 0">
      <span :class='priceClasses'>
        <span class='el:amx-Fs(0.875em) el:amx-Mr(0.25em) el:amx-C_green3 el:amx-Fw(b)'>$ {{ formattedPrice }}</span><span class='el:amx-Fs(0.75em)' v-if="course.subscription_type">/{{ $t(`dictionary.subscription_period.${course.subscription_period.unit}`) }}</span>
      </span>
    </div>
    <div class='el:amx-Mb(0.25em)' v-else>
      <span class='el:amx-Fs(0.875em) el:amx-C_green3 el:amx-Fw(b) el:amx-Tt(u)'>
        {{ $t('dictionary.free') }}
      </span>
    </div>
    <span class='el:amx-Fs(0.75em)' v-if="!course.subscription_type && price > 0">
      {{ $t('dictionary.pricing.this_course_only') }}
    </span>
    <span class='c-label' v-if="course.subscription_type">
      <div class='el:amx-D(f)'>
        <span class='c-label__text el:amx-Fs(0.75em) el:amx-Fw(b) el:amx-C_green3 el:amx-Ta(r) el:amx-Pr(0.25em)' style='flex:1;'>
          + {{ $t('dictionary.pricing.all_courses') }}
        </span>
        <span ref="tooltip">
          <icon :iconClasses="['c-label__icon','el:amx-Mt(a)','el:amx-Mb(a)','el:amx-Fs(0.875em)','el:amx-C_green3']"
                name="question"
                style="flex: 0 0 1em">
          </icon>
        </span>
      </div>
    </span>
  </div>
</template>

<script>
import tippy from '../../js/tippy';
import Icon from './Icon.vue';

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
    }
  },
  components: {
    icon: Icon
  },
  mounted() {
    this.$nextTick(function() {
      if(this.$refs.tooltip) {
        tippy(this.$refs.tooltip, {
          content: this.tooltipContent
        });
      }
    });
  },
  computed: {
    price() {
      return parseFloat(this.course.price);
    },
    formattedPrice() {
      return this.price.toLocaleString(this.$i18n.locale, {minimumFractionDigits: 2, maximumFractionDigits: 2});
    },
    trialLocale() {
      const trialPeriodUnit  = this.course.trial_period.unit;
      const trialPeriodValue = this.course.trial_period.value;
      const trialPeriodQty   = trialPeriodValue == 1 ? 'one' : 'other'
      const localeKey        = `datetime.adjectives.${trialPeriodUnit}.${trialPeriodQty}`;
      return this.$t(localeKey, {count: trialPeriodValue});
    },
    rootClassesBase() {
      return ['el:amx-D(f)','el:amx-FxDi(c)','el:amx-FxAi(fe)','el:amx-FxJc(c)'];
    },
    tooltipContent() {
      return this.$t('dictionary.pricing.tooltip',{provider: this.course.provider_name, offer: `${this.trialLocale} ${this.$t('dictionary.free_trial')}`});
    }
  }
}
</script>
