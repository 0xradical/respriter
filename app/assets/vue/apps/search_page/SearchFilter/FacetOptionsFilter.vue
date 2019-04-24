<template>
  <div class='c-search-suggest'>
    <vue-autosuggest
      :ref="id"
      :componentAttrIdAutosuggest="id"
      componentAttrClassAutosuggestResults="c-search-suggest__suggestions"
      componentAttrClassAutosuggestResultsContainer="mx-D(n)"
      :suggestions="suggestions"
      :input-props="{id: inputId, onInputChange: inputChanged , placeholder: placeholder, class: 'c-search-suggest__input'}"
      @selected="selectedSuggestion"
      @click="clickedSuggestion">
      <template slot-scope="{suggestion}">
        <span class="c-search-suggestion__suggestion">{{suggestion.item.name}}</span>
      </template>
    </vue-autosuggest>
  </div>
</template>

<script>
export default {
  props: {
    name: {
      type: String,
      required: true
    },
    placeholder: {
      type: String,
      required: true
    },
    suggestions: {
      type: Array,
      required: true
    }
  },
  methods: {
    clickedSuggestion: function(suggestion) {
      this.$emit('clickedFacetOptionSuggestion', suggestion);
      this.$refs[this.id].searchInput = '';
    },
    selectedSuggestion: function(suggestion) {
      this.$emit('selectedFacetOptionSuggestion', suggestion);
      this.$refs[this.id].searchInput = '';
    },
    inputChanged: function(...params) {
      this.$emit('changedInputFacetOptionSuggestion', ...params);
    }
  },
  computed: {
    id() {
      return `suggestions.${name}`;
    },
    inputId() {
      return `suggestions.${name}__input`;
    }
  }
}
</script>

