<template>
  <div class="clspt:contact-us">
    <contact-us-form
      :contact="contact"
      :authToken="authToken"
      v-if="!submitted"
      @submitted="submit"
    >
    </contact-us-form>
    <contact-us-successful v-if="submitted" @goback="submit">
    </contact-us-successful>
  </div>
</template>

<script>
  import ContactUsForm from "./Form.vue";
  import ContactUsSuccessful from "./Success.vue";

  export default {
    data() {
      return {
        contact: this.createContact(),
        submitted: false,
        body: undefined
      };
    },
    props: {
      locale: {
        type: String,
        required: false,
        default: "en"
      },
      authToken: {
        type: String,
        required: true
      }
    },
    components: {
      ContactUsForm,
      ContactUsSuccessful
    },
    mounted() {
      this.body = document?.getElementsByTagName("body")[0];
    },
    methods: {
      createContact() {
        return {
          name: undefined,
          email: undefined,
          reason: "",
          subject: undefined,
          message: undefined
        };
      },
      submit() {
        this.contact = Object.assign(this.createContact(), {
          name: this.contact.name,
          email: this.contact.email
        });
        this.submitted = !this.submitted;
        this.body?.scrollIntoView();
      }
    }
  };
</script>
