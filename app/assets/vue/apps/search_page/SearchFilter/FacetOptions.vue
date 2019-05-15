<template>
  <div :class='rootClasses'>
    <span v-if='noOptions' :class='noOptionsClasses' v-html='noOptionsMessage'></span>
    <ul>
      <li v-for='option in options' :key="option.id">
        <div class='c-checkbox' :class='checkboxClasses'>
          <div class='c-checkbox__selector'>
            <input :checked="includedOption(option.id)" :value="option.id" type="checkbox"/>
            <label @click="toggleOption(option.id)"></label>
          </div>
          <span @click="toggleOption(option.id)" class='c-checkbox__label'>{{ option.name }}<span class='c-checkbox__summary'> ({{ option.count }})</span></span>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  props: {
    options: {
      type: Array,
      required: true
    },
    noOptionsMessage: {
      type: String
    },
    noOptionsClasses: {
      type: Array,
      required: false,
      default() {
        return [];
      }
    },
    filter: {
      type: Array,
      required: true,
    },
    rootClasses: {
      type: Array,
      required: false,
      default() {
        return [];
      }
    },
    checkboxClasses: {
      type: Array,
      required: false,
      default() {
        return [];
      }
    }
  },
  methods: {
    toggleOption: function(option) {
      if(this.includedOption(option)){
        this.$emit('excludeFacetOption', option);
      } else {
        this.$emit('includeFacetOption', option);
      }
    },
    includedOption: function(option) {
      return this.filter.includes(option);
    }
  },
  computed: {
    noOptions() {
      return (this.noOptionsMessage !== '' || this.noOptionsMessage !== null) && this.options.length === 0;
    }
  }
}
</script>

<style lang="scss" scoped>
ul {
  list-style:none;
  margin:0;
  padding:0;

  li {
    line-height: 1em;
    margin-bottom: 0.4375em;
  }
}
</style>
