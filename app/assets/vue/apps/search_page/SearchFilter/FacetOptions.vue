<template>
  <ul :class='rootClasses'>
    <li v-for='option in options' :key="option.id">
      <div class='c-checkbox'>
        <div class='c-checkbox__selector'>
          <input :checked="includedOption(option.id)" :value="option.id" type="checkbox"/>
          <label @click="toggleOption(option.id)"></label>
        </div>
        <span class='c-checkbox__label'>{{ option.name }}<span class='c-checkbox__summary'> ({{ option.count }})</span></span>
      </div>
    </li>
  </ul>
</template>

<script>
export default {
  props: {
    options: {
      type: Array,
      required: true
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
  }
}
</script>

<style lang="scss" scoped>
ul {
  list-style:none;
  margin:0;
  padding:0;

  li {
    font-size: 0.875rem;
    line-height: 1rem;
    margin-bottom: 0.5rem;
  }
}
</style>
