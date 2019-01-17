<template>
  <ul class='c-pagination'>

    <li class='c-pagination__page' v-if='currentPage != 1'>
      <a :href='paginationAnchor' @click='$emit("paginate", currentPage - 1)'></a>
    </li>

    <li class='c-pagination__page' v-if='currentPage - pace > 1'>
      <a :href='paginationAnchor' @click='$emit("paginate", 1)'>
        1 
      </a>
    </li>
    <li class='c-pagination__page' v-if='currentPage - pace > 1'> ... </li>

    <li :class='{ "c-pagination__page--current": (currentPage === page) }' class='c-pagination__page' v-for='page in pages'>
      <a :href='paginationAnchor' @click='$emit("paginate", page)'>
        {{ page }}
      </a>
    </li>

    <li class='c-pagination__page' v-if='currentPage + pace < numOfPages'> ... </li>

    <li class='c-pagination__page' v-if='currentPage + pace < numOfPages'>
      <a :href='paginationAnchor' @click='$emit("paginate", numOfPages)'>
        {{ numOfPages }}
      </a>
    </li>

    <li class='c-pagination__page' v-if='currentPage != numOfPages'> 
      <a :href='paginationAnchor' @click='$emit("paginate", currentPage + 1)'></a>
    </li>

    <li style='clear:both'></li>

  </ul>
</template>
<script>
  export default {
    props: {

      currentPage: {
        type: Number,
        default: 1
      },

      recordsPerPage: {
        type: Number,
        default: 25
      },

      paginationAnchor: {
        type: String,
        default: ''
      },

      pace: {
        type: Number,
        default: 4
      },

      numOfPages: {
        type: Number,
        default: 0
      }

    },

    data () {
      return {}
    },

    watch: {

     // currentPage: function (nVal, oVal) {
    //    this.$emit('paginate', nVal)
    //  }

    },

    computed: {

      pages () {
        var pages = []
        for (var i=(Math.max(this.currentPage - this.pace, 1)); i < Math.min(this.currentPage + this.pace, this.numOfPages); i++) {
          pages.push(i)
        }
        return pages
      }

    },

    methods: {

      nextPage () {
        Math.min(this.currentPage += 1, this.numOfPages)
      },

      previousPage () {
        Math.max(this.currentPage -= 1, 1)
      }

    }

  }
</script>

<style scoped lang='scss'>

  .c-pagination {

    list-style: none;
    margin: 10px 0px;
    padding: 0;
    clear: both;

    &__page {

      float: left;
      margin-right: 10px;

      &--current a {
        background-color: #4C636F;
        color: #FFF;
        padding: 0px 4px;
        border-radius: 3px;
      }

    }

  }

</style>
