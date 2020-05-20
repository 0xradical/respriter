<template>
  <footer>
    <div class="el:amx-C_fgV el:amx-Bc_bgV el:amx-Pt(2em) el:amx-Pb(2em)">
      <div class="container">
        <div class="row">
          <div class="col-12 col-md-3">
            <h2 class="el:amx-Fs(1em) el:amx-C_fgM el:amx-Mb(1.75em)">
              {{ $t("dictionary.categories") }}
            </h2>
            <ul class="el:m-list el:m-list--unstyled el:amx-C_fgV">
              <li class="el:amx-Mb(1em)" v-for="tag in $rootTags" :key="tag.id">
                <a
                  :href="categoryPath(tag.id)"
                  class="el:amx-Fs(0.875em) c-link c-link--white"
                  >{{ $t(`tags.${tag.id}`) }}</a
                >
              </li>
            </ul>
          </div>

          <div class="col-12 col-md-2">
            <h2
              class="el:amx-Fs(1em) el:amx-C_fgM el:amx-Mt(0.875em)@sm el:amx-Mb(1.75em)"
            >
              {{ $t("dictionary.providers") }}
            </h2>
            <ul class="el:m-list el:amx-Fs(0.875em)">
              <li class="el:amx-Mb(1em)">
                <a
                  href="https://www.udemy.com"
                  class="el:amx-C_fgV c-link c-link--white"
                  target="_blank"
                  rel="nofollow"
                >
                  Udemy
                </a>
              </li>
              <li class="el:amx-Mb(1em)">
                <a
                  href="https://www.pluralsight.com"
                  class="el:amx-C_fgV c-link c-link--white"
                  target="_blank"
                  rel="nofollow"
                >
                  Pluralsight
                </a>
              </li>
              <li class="el:amx-Mb(1em)">
                <a
                  href="https://www.coursera.org"
                  class="el:amx-C_fgV c-link c-link--white"
                  target="_blank"
                  rel="nofollow"
                >
                  Coursera
                </a>
              </li>
              <li class="el:amx-Mb(1em)">
                <a
                  href="https://www.linkedin.com/learning"
                  class="el:amx-C_fgV c-link c-link--white"
                  target="_blank"
                  rel="nofollow"
                >
                  Linkedin Learning
                </a>
              </li>
              <li class="el:amx-Mb(1em)">
                <a
                  href="https://edx.org"
                  class="el:amx-C_fgV c-link c-link--white"
                  target="_blank"
                  rel="nofollow"
                >
                  Edx
                </a>
              </li>
              <li>
                <a
                  href="https://teamtreehouse.com"
                  class="el:amx-C_fgV c-link c-link--white"
                  target="_blank"
                  rel="nofollow"
                >
                  Treehouse
                </a>
              </li>
            </ul>
          </div>

          <div class="col-12 col-md-3">
            <h2
              class="el:amx-Fs(1em) el:amx-C_fgM el:amx-Mt(0.875em)@sm el:amx-Mb(1.75em)"
            >
              Classpert Index Tool
            </h2>
            <ul class="el:m-list el:amx-Fs(0.875em)">
              <li class="el:amx-Mb(1em)">
                <a
                  href="https://listing.classpert.com"
                  class="el:amx-C_fgV c-link c-link--white"
                >
                  <img
                    src="../assets/flask.svg"
                    class="el:amx-Mr(0.125em)"
                    style="vertical-align:bottom;width:1.125em;height:1.125em"
                  />
                  Get Listed <sup>beta</sup>
                </a>
              </li>
              <li>
                <a
                  href="https://listing.classpert.com/docs"
                  class="el:amx-C_fgV c-link c-link--white"
                  target="_blank"
                >
                  Documentation
                </a>
              </li>
            </ul>

            <h2
              class="el:amx-Fs(1em) el:amx-C_fgM el:amx-Mt(1em) el:amx-Mb(1.75em)"
            >
              {{ $t("dictionary.about") }}
            </h2>
            <ul class="el:m-list el:amx-Fs(0.875em)">
              <li class="el:amx-Mb(1em)">
                <a
                  href="/blog"
                  class="el:amx-C_fgV c-link c-link--white"
                  target="_blank"
                >
                  {{ $t("dictionary.blog") }}
                </a>
              </li>
              <li>
                <a href="/contact-us" class="el:amx-C_fgV c-link c-link--white">
                  {{ $t("contact_us.new.title") }}
                </a>
              </li>
            </ul>
          </div>

          <div class="col-12 col-md-4 el:amx-Ta(r)">
            <span style="display:inline-block;vertical-align:middle">
              <span class="el:amx-C_fgM el:amx-Fs(1em) el:amx-Fw(b)"
                >Follow us!</span
              >
              &nbsp;
              <ul
                style="display:inline-block;vertical-align:middle"
                class="el:m-list el:m-list--hrz el:amx-Fs(0.875em)"
              >
                <li class="el:amx-Pr(0.5em)">
                  <a href="https://facebook.com/classpert" target="_blank">
                    <svg class="el:amx-Fi_fgV" width="1.5em" height="1.5em">
                      <use xlink:href="#icons-facebook-circle" />
                    </svg>
                  </a>
                </li>
                <li class="el:amx-Pr(0.5em)">
                  <a
                    href="https://linkedin.com/company/classpert"
                    target="_blank"
                  >
                    <svg class="el:amx-Fi_fgV" width="1.5em" height="1.5em">
                      <use xlink:href="#icons-linkedin-circle" />
                    </svg>
                  </a>
                </li>
                <li class="el:amx-Pr(0.5em)">
                  <a href="https://instagram.com/classpert" target="_blank">
                    <svg class="el:amx-Fi_fgV" width="1.5em" height="1.5em">
                      <use xlink:href="#icons-instagram-circle" />
                    </svg>
                  </a>
                </li>
                <li>
                  <a href="https://twitter.com/classpert" target="_blank">
                    <svg class="el:amx-Fi_fgV" width="1.5em" height="1.5em">
                      <use xlink:href="#icons-twitter-circle" />
                    </svg>
                  </a>
                </li>
              </ul>
            </span>
          </div>
        </div>
      </div>
    </div>

    <div class="el:amx-Bc_suV el:amx-P(1em|0)" style="padding:16px 0px">
      <div class="container">
        <div class="row">
          <div class="col-12 el:amx-Fs(0.875em)">
            <div style="display:flex;align-items:center">
              <div style="width:80%">
                <a
                  :href="webAppURL('terms-and-conditions')"
                  class="c-link c-link--white el:amx-Fs(0.875em)"
                  style="line-height:32px"
                >
                  &nbsp; &nbsp;
                  {{ $t("dictionary.terms_and_conditions") }}
                </a>
                <a
                  :href="webAppURL('privacy-policy')"
                  class="c-link c-link--white el:amx-Fs(0.875em)"
                  style="line-height:32px"
                >
                  &nbsp; &nbsp;
                  {{ $t("dictionary.privacy_policy") }}
                </a>
              </div>
              <div style="width:20%">
                <svg
                  class="el:amx-Fi_fgV el:amx-F(r) el:amx-D(n)@sm"
                  width="123px"
                  height="20px"
                >
                  <use xlink:href="#brand-logo" />
                </svg>
                <svg
                  class="el:amx-Fi_fg el:amx-F(r) el:amx-D(n)@>lg"
                  height="20px"
                  width="20px"
                >
                  <use xlink:href="#brand-logo_symbol" />
                </svg>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>

<script>
export default {
  data() {
    return {};
  },

  methods: {
    categoryPath(category) {
      return (
        this.$domains[this.$store.state.locale.code] +
        "/" +
        category.replace("_", "-")
      );
    },

    webAppURL(path) {
      return (
        this.$domains[this.$store.state.locale.code] +
        "/" +
        path.replace("_", "-")
      );
    }
  }
};
</script>
<style lang="scss">
.c-link {
  text-decoration: none;
  &--white {
    color: #fff !important;
    &:hover {
      color: #fff !important;
    }
  }
}
</style>
