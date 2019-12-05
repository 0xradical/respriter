<template>
  <div class="c-search-suggest">
    <client-only>
      <input
        type="text"
        slot="placeholder"
        autocomplete="off"
        role="combobox"
        aria-autocomplete="list"
        aria-owns="autosuggest__results"
        aria-activedescendant=""
        aria-haspopup="false"
        aria-expanded="false"
        :placeholder="placeholder"
        name="q"
        class="c-search-suggest__input"
      />
      <vue-autosuggest
        :ref="id"
        :componentAttrIdAutosuggest="id"
        componentAttrClassAutosuggestResults="c-search-suggest__suggestions"
        componentAttrClassAutosuggestResultsContainer="mx-D(n)"
        :suggestions="suggestions"
        :input-props="{
          id: inputId,
          onInputChange: inputChanged,
          placeholder: placeholder,
          class: 'c-search-suggest__input'
        }"
        @selected="selectedSuggestion"
        @click="clickedSuggestion"
      >
        <template slot-scope="{ suggestion }">
          <span class="c-search-suggestion__suggestion">{{
            suggestion.item.name
          }}</span>
        </template>
      </vue-autosuggest>
    </client-only>
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
      this.$emit("clickedFacetOptionSuggestion", suggestion);
      this.$refs[this.id].searchInput = "";
    },
    selectedSuggestion: function(suggestion) {
      this.$emit("selectedFacetOptionSuggestion", suggestion);
      this.$refs[this.id].searchInput = "";
    },
    inputChanged: function(...params) {
      this.$emit("changedInputFacetOptionSuggestion", ...params);
    }
  },
  computed: {
    id() {
      return `suggestions.${this.name}`;
    },
    inputId() {
      return `suggestions.${this.name}__input`;
    }
  }
};
</script>
