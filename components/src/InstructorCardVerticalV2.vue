<template>
  <a :href="instructor.profilePath" class="d-b">
    <div class="el:o-profile-vcard" style="width: 255px;">
      <div
        class="el:o-profile-vcard__cover-slot"
        :style="{
          backgroundImage:
            instructor.subject &&
            instructor.subjectImageUrl &&
            `url(${instructor.subjectImageUrl})`
        }"
      ></div>
      <div class="el:o-profile-vcard__avatar-slot">
        <img
          :src="instructor.avatarUrl"
          :alt="instructor.name"
          style="border-radius: 50%; width: 100%; height: 100%;"
        />
      </div>
      <span class="el:o-profile-vcard__title">
        {{ truncate(instructor.name) }}
      </span>
      <div class="el:o-profile-vcard__head-slot">
        <ul class="el:m-list el:m-list--hrz">
          <li
            v-for="provider in instructor.teachingAt"
            :key="provider"
            class="mR8"
          >
            <svg width="1.6rem" height="1.6rem">
              <use :xlink:href="`#providers-${providerIcon(provider)}`" />
            </svg>
          </li>
          <li v-if="instructor.website">
            <svg width="1.6rem" height="1.6rem">
              <use xlink:href="#icons-website" />
            </svg>
          </li>
        </ul>
      </div>
      <div class="el:o-profile-vcard__body-slot">
        <div class="d-f">
          <svg width="1.2rem" height="1.2rem" class="mR8 fi-fgM">
            <use xlink:href="#icons-camera" />
          </svg>
          <span class="fs12 c-fgM">
            <ssrt
              k="dictionary.instructor.courses_count"
              :options="{ count: instructor.courseCount }"
            />
          </span>
        </div>
        <div class="d-f mT8">
          <svg width="1.2rem" height="1.2rem" class="mR8 fi-fgM">
            <use xlink:href="#icons-monitor-gear" />
          </svg>
          <span class="fs12 c-fgM">
            <template v-if="instructor.subject">
              <ssrt :k="`tags.${instructor.subject}`" />
            </template>
            <template v-else>
              <ssrt k="dictionary.not_available" />
            </template>
          </span>
        </div>
      </div>
    </div>
  </a>
</template>

<script>
  import { lowerCase } from "lodash";
  import { compose, replace, slice } from "ramda";

  export default {
    props: {
      instructor: {
        avatarUrl: {
          type: String,
          required: false
        },
        profilePath: {
          type: String,
          required: true
        },
        name: {
          type: String,
          required: false
        },
        website: {
          type: String,
          required: false
        },
        subject: {
          type: String,
          required: false
        },
        subjectImageUrl: {
          type: String,
          required: false
        },
        teachingAt: {
          type: Array,
          default() {
            return [];
          }
        },
        courseCount: {
          type: Number,
          default: 0
        }
      }
    },
    methods: {
      truncate: slice(0, 26),
      providerIcon: compose(replace(/\s/g, "-"), lowerCase)
    }
  };
</script>
