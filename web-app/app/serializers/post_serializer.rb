# frozen_string_literal: true

class PostSerializer
  include FastJsonapi::ObjectSerializer
  extend ActionView::Helpers::AssetUrlHelper
  extend ActionView::Helpers::SanitizeHelper
  extend Minipack::Helper
  set_key_transform :camel_lower

  class << self
    def strip_tags(*args)
      Loofah.fragment(*args).to_text(encode_special_chars: false)
    end

    def truncate(*args)
      ActionController::Base.helpers.truncate(*args)
    end
  end

  attributes :title, :slug

  attribute :published_at do |object|
    I18n.l(object.published_at, format: '%B %d, %Y')
  end

  attribute :cover_image do |object|
    object.images&.first&.thumbor&.file_url(width: 728)
  end

  attribute :subtitle do |object|
    truncate(strip_tags(object.body.html_safe).gsub(/\n+/, ' ').gsub(/#img[^\s]+/, ''), length: 250, escape: false)
  end

  def self.to_proc
    ->(object) { new(object).serializable_hash.dig(:data, :attributes) }
  end
end
