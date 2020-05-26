<template>
  <div class="row">
    <div class="col">
      <p>{{ $t("user.sections.interests.info_text") }}</p>

      <h3 class="el:amx-Fs(1.25em) el:amx-Mb(0.5em)">
        {{ $t("user.sections.interests.select_a_topic_title") }}
      </h3>

      <multiselect
        :searchable="true"
        :options="mappedOptions"
        label="label"
        track-by="tag"
        @select="addInterest"
        :placeholder="$t('user.sections.interests.placeholder')"
        :selectLabel="$t('user.sections.interests.select')"
        :deselectLabel="$t('user.sections.interests.deselect')"
        :close-on-select="true"
      >
        <template slot="option" slot-scope="props">
          <span class="el:m-label el:amx-Fs(1em)">
            <svg class="el:m-label__icon el:amx-Mr(0.5em) el:amx-Fs(1.25em)">
              <use :xlink:href="`#tags-${props.option.tag}`" />
            </svg>
            <span class="el:m-label__text">{{
              $t(`tags.${props.option.tag}`)
            }}</span>
          </span>
        </template>
      </multiselect>

      <h3
        class="el:amx-Fs(1.25em) el:amx-Mt(1em)"
        v-if="mappedInterests.length > 0"
      >
        {{ $t("user.sections.interests.interests_title") }}
      </h3>

      <div class="row">
        <div
          v-for="interest in mappedInterests"
          class="col-12 col-md-6"
          :key="interest.tag"
        >
          <div class="el:m-sticker el:amx-Mt(1em)">
            <div class="el:m-sticker__media">
              <svg>
                <use :xlink:href="`#tags-${interest.tag}`"></use>
              </svg>
            </div>
            <div class="el:m-sticker__text">
              <div class="el:m-sticker__primary-label">
                <a :href="slug(interest.tag)" target="_blank">
                  {{ $t(`tags.${interest.tag}`) }}
                </a>
              </div>
            </div>
            <a
              href="javascript:void(0)"
              @click="removeInterest(interest)"
              class="el:m-sticker__delete"
            ></a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { map, reduce, without, values } from "lodash";
import { createNamespacedHelpers as helpers } from "vuex";
import namespaces from "~store/namespaces";
import { operations } from "~store/types";

const { mapActions, mapMutations } = helpers(namespaces.PROFILE);

export default {
  data() {
    return {
      loading: true,
      interests: [],
      options: {}
    };
  },

  created() {
    this.initProfile({ userAccountId: this.$session.getUserId() }).then(() => {
      this.options = this.loadOptions();
      this.interests = this.$store.state.profile.interests;
      this.loading = false;
    });
  },

  computed: {
    mappedInterests() {
      if (Object.keys(this.options).length) {
        return map(this.interests, tag => {
          return this.options[tag];
        });
      } else {
        return [];
      }
    },

    mappedOptions() {
      return values(this.options);
    }
  },

  methods: {
    slug(tag) {
      return `${this.$domains[this.$store.state.locale.code]}/${tag.replace(
        "_",
        "-"
      )}?utm_source=user_dashboard&utm_campaign=${tag}&utm_medium=interests`;
    },

    ...mapMutations({
      change: operations.UPDATE
    }),
    ...mapActions({
      initProfile: operations.GET,
      persist: operations.UPDATE
    }),

    loadOptions() {
      const tags = this.$i18n.messages[this.$store.state.locale.code]["tags"];

      return reduce(
        tags,
        (r, v, k) => {
          r[k] = {
            tag: k,
            label: v,
            $isDisabled: this.$store.state.profile?.interests?.includes(k)
              ? true
              : false
          };
          return r;
        },
        {}
      );
    },

    addInterest(option) {
      option.$isDisabled = true;
      this.interests = [...this.interests, option.tag];

      this.persist({
        userAccountId: this.$session.getUserId(),
        payload: { interests: this.interests }
      });
    },

    removeInterest(option) {
      this.interests = without(this.interests, option.tag);
      option.$isDisabled = false;

      this.persist({
        userAccountId: this.$session.getUserId(),
        payload: { interests: this.interests }
      });
    }
  }
};
</script>
<style lang="scss">
.multiselect__option.multiselect__option--group.multiselect__option--disabled {
  .el\:m-label__icon {
    opacity: 0.3;
  }
}

fieldset[disabled] .multiselect {
  pointer-events: none;
}
.multiselect__spinner {
  position: absolute;
  right: 1px;
  top: 1px;
  width: 48px;
  height: 35px;
  background: #fff;
  display: block;
}
.multiselect__spinner:before,
.multiselect__spinner:after {
  position: absolute;
  content: "";
  top: 50%;
  left: 50%;
  margin: -8px 0 0 -8px;
  width: 16px;
  height: 16px;
  border-radius: 100%;
  border-color: #41b883 transparent transparent;
  border-style: solid;
  border-width: 2px;
  box-shadow: 0 0 0 1px transparent;
}
.multiselect__spinner:before {
  animation: spinning 2.4s cubic-bezier(0.41, 0.26, 0.2, 0.62);
  animation-iteration-count: infinite;
}
.multiselect__spinner:after {
  animation: spinning 2.4s cubic-bezier(0.51, 0.09, 0.21, 0.8);
  animation-iteration-count: infinite;
}
.multiselect__loading-enter-active,
.multiselect__loading-leave-active {
  transition: opacity 0.4s ease-in-out;
  opacity: 1;
}
.multiselect__loading-enter,
.multiselect__loading-leave-active {
  opacity: 0;
}
.multiselect,
.multiselect__input,
.multiselect__single {
  font-family: inherit;
  font-size: 16px;
  touch-action: manipulation;
}
.multiselect {
  box-sizing: content-box;
  display: block;
  position: relative;
  width: 100%;
  min-height: 40px;
  text-align: left;
  color: #35495e;
}
.multiselect * {
  box-sizing: border-box;
}
.multiselect:focus {
  outline: none;
}
.multiselect--disabled {
  background: get-color("gray1");
  pointer-events: none;
  opacity: 0.6;
}
.multiselect--active {
  z-index: 50;
}
.multiselect--active:not(.multiselect--above) .multiselect__current,
.multiselect--active:not(.multiselect--above) .multiselect__input,
.multiselect--active:not(.multiselect--above) .multiselect__tags {
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
}
.multiselect--active .multiselect__select {
  transform: rotateZ(180deg);
}
.multiselect--above.multiselect--active .multiselect__current,
.multiselect--above.multiselect--active .multiselect__input,
.multiselect--above.multiselect--active .multiselect__tags {
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}
.multiselect__input,
.multiselect__single {
  position: relative;
  display: inline-block;
  min-height: 20px;
  line-height: 20px;
  border: none;
  border-radius: 5px;
  background: #fff;
  padding: 0 0 0 5px;
  width: calc(100%);
  transition: border 0.1s ease;
  box-sizing: border-box;
  margin-bottom: 8px;
  vertical-align: top;
}
.multiselect__input::placeholder {
  color: #35495e;
}
.multiselect__tag ~ .multiselect__input,
.multiselect__tag ~ .multiselect__single {
  width: auto;
}
.multiselect__input:hover,
.multiselect__single:hover {
  border-color: #cfcfcf;
}
.multiselect__input:focus,
.multiselect__single:focus {
  border-color: #a8a8a8;
  outline: none;
}
.multiselect__single {
  padding-left: 5px;
  margin-bottom: 8px;
}
.multiselect__tags-wrap {
  display: inline;
}
.multiselect__tags {
  min-height: 40px;
  display: block;
  padding: 8px 40px 0 8px;
  border-radius: 5px;
  border: 1px solid #e8e8e8;
  background: #fff;
  font-size: 14px;
}
.multiselect__tag {
  position: relative;
  display: inline-block;
  padding: 4px 26px 4px 10px;
  border-radius: 5px;
  margin-right: 10px;
  color: #fff;
  line-height: 1;
  background: #027aff;
  margin-bottom: 5px;
  white-space: nowrap;
  overflow: hidden;
  max-width: 100%;
  text-overflow: ellipsis;
}
.multiselect__tag-icon {
  cursor: pointer;
  margin-left: 7px;
  position: absolute;
  right: 0;
  top: 0;
  bottom: 0;
  font-weight: 700;
  font-style: initial;
  width: 22px;
  text-align: center;
  line-height: 22px;
  transition: all 0.2s ease;
  border-radius: 5px;
}
.multiselect__tag-icon:after {
  content: "×";
  color: #266d4d;
  font-size: 14px;
}
.multiselect__tag-icon:focus,
.multiselect__tag-icon:hover {
  background: #369a6e;
}
.multiselect__tag-icon:focus:after,
.multiselect__tag-icon:hover:after {
  color: white;
}
.multiselect__current {
  line-height: 16px;
  min-height: 40px;
  box-sizing: border-box;
  display: block;
  overflow: hidden;
  padding: 8px 12px 0;
  padding-right: 30px;
  white-space: nowrap;
  margin: 0;
  text-decoration: none;
  border-radius: 5px;
  border: 1px solid #e8e8e8;
  cursor: pointer;
}
.multiselect__select {
  line-height: 16px;
  display: block;
  position: absolute;
  box-sizing: border-box;
  width: 40px;
  height: 38px;
  right: 1px;
  top: 1px;
  padding: 4px 8px;
  margin: 0;
  text-decoration: none;
  text-align: center;
  cursor: pointer;
  transition: transform 0.2s ease;
}
.multiselect__select:before {
  position: relative;
  right: 0;
  top: 65%;
  color: #999;
  margin-top: 4px;
  border-style: solid;
  border-width: 5px 5px 0 5px;
  border-color: #999999 transparent transparent transparent;
  content: "";
}
.multiselect__placeholder {
  color: get-color("gray2");
  display: inline-block;
  margin-bottom: 10px;
  padding-top: 2px;
}
.multiselect--active .multiselect__placeholder {
  display: none;
}
.multiselect__content-wrapper {
  position: absolute;
  display: block;
  background: #fff;
  width: 100%;
  max-height: 240px;
  overflow: auto;
  border: 1px solid #e8e8e8;
  border-top: none;
  border-bottom-left-radius: 5px;
  border-bottom-right-radius: 5px;
  z-index: 50;
  -webkit-overflow-scrolling: touch;
}
.multiselect__content {
  list-style: none;
  display: inline-block;
  padding: 0;
  margin: 0;
  min-width: 100%;
  vertical-align: top;
}
.multiselect--above .multiselect__content-wrapper {
  bottom: 100%;
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
  border-top-left-radius: 5px;
  border-top-right-radius: 5px;
  border-bottom: none;
  border-top: 1px solid #e8e8e8;
}
.multiselect__content::webkit-scrollbar {
  display: none;
}
.multiselect__element {
  display: block;
}
.multiselect__option {
  display: block;
  padding: 12px;
  min-height: 40px;
  line-height: 16px;
  text-decoration: none;
  text-transform: none;
  vertical-align: middle;
  position: relative;
  cursor: pointer;
  white-space: nowrap;
  border-left: 2px solid transparent;
}
.multiselect__option:after {
  top: 0;
  right: 0;
  position: absolute;
  line-height: 40px;
  padding-right: 12px;
  padding-left: 20px;
  font-size: 13px;
}
.multiselect__option--highlight {
  border-left: 2px solid var(--primary);
  outline: none;
  color: var(--primary);
  font-weight: bold;
}
.multiselect__option--highlight:after {
  content: attr(data-select);
  color: var(--primary);
}
.multiselect__option--selected {
  background: #f3f3f3;
  color: #35495e;
  font-weight: bold;
}
.multiselect__option--selected:after {
  content: attr(data-selected);
  color: silver;
}
.multiselect__option--selected.multiselect__option--highlight {
  background: #ff6a6a;
  color: #fff;
}
.multiselect__option--selected.multiselect__option--highlight:after {
  background: #ff6a6a;
  content: attr(data-deselect);
  color: #fff;
}
.multiselect--disabled .multiselect__current,
.multiselect--disabled .multiselect__select {
  color: get-color("gray2") !important;
}
.multiselect__option--disabled {
  color: get-color("gray2") !important;
  cursor: text;
  pointer-events: none;
}
.multiselect__option--group {
  color: #35495e;
}
.multiselect__option--group.multiselect__option--highlight {
  background: #35495e;
  color: #fff;
}
.multiselect__option--group.multiselect__option--highlight:after {
  background: #35495e;
}
.multiselect__option--disabled.multiselect__option--highlight {
  /*background: #dedede;*/
}
.multiselect__option--group-selected.multiselect__option--highlight {
  background: #ff6a6a;
  color: #fff;
}
.multiselect__option--group-selected.multiselect__option--highlight:after {
  background: #ff6a6a;
  content: attr(data-deselect);
  color: #fff;
}
.multiselect-enter-active,
.multiselect-leave-active {
  transition: all 0.15s ease;
}
.multiselect-enter,
.multiselect-leave-active {
  opacity: 0;
}
.multiselect__strong {
  margin-bottom: 8px;
  line-height: 20px;
  display: inline-block;
  vertical-align: top;
}
*[dir="rtl"] .multiselect {
  text-align: right;
}
*[dir="rtl"] .multiselect__select {
  right: auto;
  left: 1px;
}
*[dir="rtl"] .multiselect__tags {
  padding: 8px 8px 0px 40px;
}
*[dir="rtl"] .multiselect__content {
  text-align: right;
}
*[dir="rtl"] .multiselect__option:after {
  right: auto;
  left: 0;
}
*[dir="rtl"] .multiselect__clear {
  right: auto;
  left: 12px;
}
*[dir="rtl"] .multiselect__spinner {
  right: auto;
  left: 1px;
}
@keyframes spinning {
  from {
    transform: rotate(0);
  }
  to {
    transform: rotate(2turn);
  }
}
</style>
