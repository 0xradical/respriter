Premailer::Rails.config.merge!({
  preserve_styles: false,
  remove_ids: false,
  strategies: [:asset_pipeline, :filesystem, :network]
})
