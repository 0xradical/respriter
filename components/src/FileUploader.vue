<template>

  <div>
    <div class='el:m-file-input'>
      <button type='button' class='el:m-file-input__btn'>{{ label }}</button>
      <input ref='fileInput' :accept='accept' :multiple='multiple' @change="onFileInputChange" type='file' />
    </div>
    <slot :uploadList='uploadList' :uploadHandler='upload'></slot>
  </div>

</template>
<script>

  const $xhr = require('axios').create()
  const $m   = require('deepmerge')

  const FILE_SIZE_REGEX = /([0-9.]*)\s?(M|K|G)B?/i
  const UNIT_PREFIX     = { 'K': 10**3, 'M': 10**6, 'G': 10**9 }

  export default {

    props: {

      auto: {
        type: Boolean,
        default: true
      },

      url: {
        type: String,
        required: false
      },

      axiosConfig: {
        type: Object,
        required: false
      },

      alwaysCompleteProgress: {
        type: Boolean,
        default: true
      },

      maxAllowedSize: {
        type: Object,
        required: false,
        default () {
          return {
            value: '50 MB',
            feedback (item, ctx) {
              return `${item.file.name} exceeds the max allowed size of 50 MB`
            }
          }
        }
      },

      accept: {
        type: String,
        default: ''
      },

      label: {
        type: String,
        default: 'Choose File'
      },

      multiple: {
        type: Boolean,
        default: false
      }

    },

    data () {
      return {
        uploadList: []
      }
    },

    methods: {

      onFileInputChange (evt) {
        const vm = this

        this.uploadList = Array.from(evt.target.files).map((file) => {
          return this.validateFileSize({
            file: file,
            progress: {
              value: 0,
              state: 'awaiting',
              feedback: ''
            },
            params: {}
          })
        })

        this.$emit('onFilesEnqueued', this.uploadList, this.upload)

      },

      resetFileInput () {
        const input = this.$refs.fileInput
        input.type = 'text'
        input.type = 'file'
      },

      validateFileSize (uploadItem) {
        let size   = FILE_SIZE_REGEX.exec(this.maxAllowedSize.value)
        if (!size) throw `${this.maxAllowedSize.value} is not a valid size`
        let factor = UNIT_PREFIX[size[2].toUpperCase()]
        if (uploadItem.file.size >= (size[1] * factor)) {
          uploadItem['valid']    = false
          uploadItem['feedback'] = this.maxAllowedSize.feedback(uploadItem, this)
        } else {
          uploadItem['valid'] = true
        }
        return uploadItem
      },

      upload (item, localConf={}) {

        let vm = this

        let defaultConf = {
          method: 'post',
          headers: {},
          responseType: 'json'
        }

        let conf = $m.all([defaultConf, this.axiosConfig, localConf])

        conf['data'] = item.file

        conf['onUploadProgress'] = function (pEvt) { vm.onUploadProgress(item, pEvt) }

        $xhr.request(conf).then((r) => { vm.onUploadSuccess(item, r) }).catch((r) => { vm.onUploadError(item, r) })

      },

      onUploadProgress (item, pEvt) {
        item.progress.value = parseInt((pEvt.loaded / pEvt.total) * 100)
        item.progress.state = 'loading'
        this.$emit('onUploadProgress', item, pEvt)
      },

      onUploadSuccess (item, resp) {
        if (this.alwaysCompleteProgress) item.progress.value = 100
        item.progress.state = 'success'
        this.$emit('onUploadSuccess', item, resp)
      },

      onUploadError (item, resp) {
        if (this.alwaysCompleteProgress) item.progress.value = 100
        item.progress.state = 'error'
        this.$emit('onUploadError', item, resp)
      },

      _isObjectEmpty (obj) {
        return Object.keys(obj).length === 0 && obj.constructor === Object
      }

    }
  }
</script>
