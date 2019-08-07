<template>
  <div class='clspt:contact-us'>
    <contact-us-form :contact="contact"
                     :auth_token="auth_token"
                     v-if='!submitted'
                     @submitted='submit'>
    </contact-us-form>
    <contact-us-successful v-if='submitted'
                           @goback='submit'>
    </contact-us-successful>
  </div>
</template>

<script>
import ContactUsForm from './Form.vue';
import ContactUsSuccessful from './Success.vue';

export default {
  data() {
    return {
      contact: this.createContact(),
      submitted: false,
      body: document.getElementsByTagName('body')[0]
    }
  },
  props: {
    locale: {
      type: String,
      required: false,
      default: 'en'
    },
    auth_token: {
      type: String,
      required: true
    }
  },
  components: {
    ContactUsForm,
    ContactUsSuccessful
  },
  methods: {
    createContact() {
      return {
        name: null,
        email: null,
        subject: null,
        message: null
      }
    },
    submit() {
      this.contact = Object.assign(this.createContact(), {
        name: this.contact.name,
        email: this.contact.email
      });
      this.submitted = !this.submitted;
      this.body.scrollIntoView();
    }
  }
}
</script>
