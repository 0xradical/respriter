<template>
  <div>
    <desktop :course="course">
      <template #similar>
        <client-only>
          <div v-if="similar.length" class="container">
            <div class="row">
              <div class="col">
                <similar
                  :courses="similar"
                  class="el:amx-Mt(1em) el:amx-Mb(1em)"
                ></similar>
              </div>
            </div>
          </div>
        </client-only>
      </template>
    </desktop>

    <mobile :course="course">
      <template #similar>
        <client-only>
          <div v-if="similar.length" class="container">
            <div class="row">
              <div class="col">
                <similar
                  :courses="similar"
                  class="el:amx-Mt(1em) el:amx-Mb(1em)"
                ></similar>
              </div>
            </div>
          </div>
        </client-only>
      </template>
    </mobile>
  </div>
</template>

<script>
  import Desktop from "components/course_page/Desktop.vue";
  import Mobile from "components/course_page/Mobile.vue";
  import Similar from "./Similar.vue";

  export default {
    name: "CoursePage",
    props: {
      course: {
        type: Object,
        required: true
      },
      locale: {
        type: String,
        required: false,
        default: "en"
      },
      similar: {
        type: Array,
        required: false,
        default() {
          return [];
        }
      }
    },
    components: {
      desktop: Desktop,
      mobile: Mobile,
      Similar
    }
  };
</script>
