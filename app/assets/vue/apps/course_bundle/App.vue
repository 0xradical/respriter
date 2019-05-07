<template>
  <div class='col-12 col-md-9'>
    <div v-for='course in data.records' :key="course.id" class='row'>
      <div class='col-12 mx-Mt-1'>
        <course :course='course'></course>
      </div>
    </div>
    <course-modal></course-modal>
  </div>
</template>

<script>

  import _ from 'lodash';
  import Course from './Course.vue';
  import CourseModal from './CourseModal.vue';

  export default {

    props: {

      locale: {
        type: String,
        default: 'en'
      }

    },

    components: {
      course: Course,
      courseModal: CourseModal
    },

    data () {
      return {
        page: 1,
        numOfPages: 0,
        data: {
          records: [],
          meta: {
            total: 0
          }
        }
      }
    },

    mounted () {
      this.fetchResults()
    },

    methods: {

      fetchResults () {
        var vm = this
        fetch(window.location.href + '.json', { method: 'GET' }).then(function (resp) {
          resp.json().then(function (json) {
            vm.data.records = json.data
          });
        });
      }
    }

  }
</script>
