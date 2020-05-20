<template>
  <div>
    <div
      class="container el:amx-Mt(6em) el:amx-Pt(2em) el:amx-Pb(2em)"
      v-if="!clickedInitiateIntegration"
    >
      <div class="row">
        <div class="offset-lg-2 col-3">
          <img src="../../assets/integration-schematic.svg" alt="Integration schematic" />
        </div>
        <div class="offset-1 col-8 offset-lg-0 col-lg-6">
          <div class="el:amx-Bc_su el:amx-W(100%)">
            <h1>Introduction</h1>
            <p>
              In order to list your courses on Classpert, we're going to need some help from you or
              a developer. Here's how our integration works:
            </p>

            <ul class="el:amx-Mt(2em) el:amx-Pl(1em)">
              <li>
                You need to have a fully working website on which you're already selling online
                courses.
              </li>

              <li class="el:amx-Mt(1em)">
                You'll need to prove the website belongs to you. It's important to have
                administrative privileges and some development knowledge.
              </li>

              <li class="el:amx-Mt(1em)">
                After verifying the ownership of your website, you'll need to add a
                <a
                  href="/docs/classpert-json-schema.html#classpert-tag"
                  target="_blank"
                  class="text-decoration-underline"
                  >special script tag</a
                >
                to every course page so we can find and publish your courses on Classpert.
              </li>
            </ul>

            <div class="el:amx-Mt(2em)" style="width:100%; text-align:center">
              <a
                href="/docs"
                target="_blank"
                class="btn btn--primary-border btn--sm el:amx-Mr(1.25em)"
              >
                Read Documentation
              </a>
              <button
                class="btn btn--primary-flat btn--sm"
                @click="clickedInitiateIntegration = true"
              >
                Start integration
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <domain-wizard v-else></domain-wizard>
  </div>
</template>
<script>
import DomainWizard from "./Wizard.vue";
export default {
  components: {
    DomainWizard
  },
  data() {
    return {
      clickedInitiateIntegration: false
    };
  }
};
</script>
