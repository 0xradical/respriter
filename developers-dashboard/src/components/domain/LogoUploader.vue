<template>
  <div>
    <file-uploader
      ref="fileUploader"
      :multiple="false"
      :axios-config="{ method: 'put', headers: { 'x-amz-acl': 'private' } }"
      :auto="false"
      :label="$t('user.components.file_uploader.file_label')"
      :max-allowed-size="maxAllowedSize"
      accept="image/jpeg,image/gif,image/png,image/svg+xml"
      @onFilesEnqueued="onFilesEnqueued"
      @onUploadProgress="onUploadProgress"
      @onUploadError="onUploadError"
      @onUploadSuccess="onUploadSuccess"
    >
      <template slot-scope="{ uploadList }">
        <ul class="el:amx-D(b) el:m-list el:m-list--unstyled el:amx-Mt(0.375em)">
          <li v-for="item in uploadList" :key="item.file.name" style="margin-bottom:8px">
            <span class="el:amx-Fs(0.75em)" v-if="item.valid">
              {{ item.file.name }}
            </span>
            <span class="el:amx-Fs(0.75em)" v-else>
              {{ item.feedback }}
            </span>
            <div class="el:amx-Mt(0.25em)">
              <progress-bar
                :progress="item.progress.value"
                :feedback="item.progress.feedback"
                :state="item.progress.state"
              >
                <div class="el:amx-D(f)">
                  <div style="flex: 1 1 80%;">
                    {{ item.progress.feedback }}
                  </div>
                  <div class="el:amx-Ta(r)" style="flex: 1 1 20%;">{{ item.progress.value }}%</div>
                </div>
              </progress-bar>
            </div>
          </li>
        </ul>
      </template>
    </file-uploader>
  </div>
</template>
<script>
import { createNamespacedHelpers as helpers } from "vuex";
import FileUploader from "~external/FileUploader.vue";
import ProgressBar from "~external/ProgressBar.vue";
import namespaces from "~store/namespaces";
import { operations } from "~store/types";

const { mapActions: mapProviderLogoActions } = helpers(namespaces.PROVIDER_LOGO);

const { mapGetters: mapSharedGetters } = helpers(namespaces.SHARED);

const File = { MAX_SIZE: "20MB" };

export default {
  data() {
    return {
      maxAllowedSize: {
        value: File.MAX_SIZE,
        feedback: item => {
          return this.$t("user.components.file_uploader.file_size_feedback", {
            file: item.file.name,
            size: File.MAX_SIZE
          });
        }
      }
    };
  },
  components: {
    FileUploader,
    ProgressBar
  },
  computed: {
    ...mapSharedGetters(["currentProvider"])
  },
  methods: {
    ...mapProviderLogoActions({
      authProviderLogo: operations.AUTH
    }),
    onFilesEnqueued(uploadList, uploadHandler) {
      // eslint-disable-next-line no-unused-vars
      const [logo, ..._rest] = uploadList;

      this.authProviderLogo({
        fileName: encodeURI(logo.file.name),
        providerId: this.currentProvider?.id
      }).then(({ upload_url, file_content_type }) => {
        return uploadHandler(logo, {
          url: upload_url,
          headers: {
            "Content-type": file_content_type
          }
        });
      });
    },
    onUploadProgress(item) {
      item.progress.feedback = this.$t("user.components.file_uploader.progress_feedback.loading");
    },
    onUploadError(item) {
      item.progress.feedback = this.$t("user.components.file_uploader.progress_feedback.error");
    },
    onUploadSuccess(item) {
      item.progress.feedback = this.$t("user.components.file_uploader.progress_feedback.success");
      this.$emit("success");
    }
  }
};
</script>
