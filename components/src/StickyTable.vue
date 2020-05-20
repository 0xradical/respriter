<template>
  <div class='el:m-table' :class="stickyColBehavior ? 'el:m-table--sticky' : ''">
    <div class='el:m-table__scrollable-content'>
      <table>

        <thead>
          <tr>

            <th :data-dt-sticky-col-checkbox="stickyColBehavior">
              <input @change='selectAll' type='checkbox' style='vertical-align:middle' /> 
            </th>

            <th v-for='(field, idx) in header'
                :data-dt-sticky-col="(field['name'] == stickyCol && stickyColBehavior)">
              <slot :name="`thead-${field['name']}`" :field='field'>{{ field['label'] }}</slot>
            </th>

            <th v-if='rowActions'>#</th>

          </tr>
        </thead>

        <tbody>
          <tr ref='row' v-for='record in data' :data-dt-row-value='JSON.stringify(record)'>

            <td :data-dt-sticky-col-checkbox="stickyColBehavior">
              <input ref='rowCheckbox' type='checkbox' :value='record[checkboxDefaultValue]' name='table' style='vertical-align:middle' /> 
            </td>

            <td v-for='(field, idx) in header'
              :title="record[field['name']]"
              :data-dt-sticky-col="(field['name'] == stickyCol && stickyColBehavior)"
              :data-dt-col-value="record[field['name']]"
              >
              <slot :name="`tbody-${field['name']}`" :record='record'>
                <template v-if='maxCharsPerField'>{{ _truncate(record, field['name']) }}</template>
                <template v-else>{{ filterFn(record, field['name']) }}</template>
              </slot>
            </td>

            <td v-if='rowActions'>
              <slot name='actions' v-bind:record='record'></slot>
            </td>

          </tr>
        </tbody>

      </table>
    </div>
  </div>
</template>
<script>
  export default {

    props: {

      checkboxDefaultValue: {
        type: String,
        default: 'id',
        required: false
      },

      stickyColBehavior: {
        type: Boolean,
        default: false
      },

      stickyCol: {
        type: String,
        required: false
      },

      rowActions: {
        type: Boolean,
        required: false,
        default: false
      },

      data: {
        type: Array,
        required: true
      },

      maxCharsPerField: {
        type: Number,
        required: false
      },

      filterFn: {
        type: Function,
        required: false,
        default (r, fName) {
          return r[fName]
        }
      },

      header: {
        type: Array,
        required: true
      }

    },

    data () {
      return {
      }
    },

    computed: {

      fieldNames() {
        return _.map(this.header, (f) => { return f['name'] })
      },

      getStickyColByIdx() {
        if (this.stickyCol) return this.fieldNames().indexOf(this.stickyCol)
        return 0
      }

    },

    methods: {

      _truncate (r, fName) {
        if (r[fName].toString().split('').length > this.maxCharsPerField) {
          return `${r[fName].toString().substring(0, this.maxCharsPerField - 3)}...`
        } else {
          return r[fName]
        }
      },

      selectAll (e) {
        this.$refs.rowCheckbox.forEach((cb) => {
          cb.checked = e.target.checked
        })
      }

    }

  }
</script>
