# frozen_string_literal: true

class Post < ApplicationRecord
  paginates_per 10

  include Imageable::HasMany
  include Slugifyable
  include ActionView::Helpers::TextHelper

  slugify :title, callback_options: { if: -> { slug.blank? }, unless: :void? }

  with_options unless: :untouched? do
    validates :title, :body, :locale, presence: true
    before_save :set_content_fingerprint
    before_save :set_content_changed_at, if: :content_changed?
  end

  after_validation -> { self.status = 'draft' }, if: :may_change_to_draft?

  belongs_to :original_version, class_name: :Post, foreign_key: :original_post_id, optional: true
  has_many :localized_versions, class_name: :Post, foreign_key: :original_post_id
  has_many :post_relations
  has_many :providers, through: :post_relations, source: :relation, source_type: 'Provider'

  belongs_to :admin_account

  scope :tags,      ->(tags = nil) { where('tags @> ARRAY[?]::varchar[]', tags) unless tags.nil? }
  scope :published, -> { where(status: 'published') }
  scope :locale,    ->(locale) { where(locale: locale) }
  scope :originals, -> { where(original_post_id: nil) }
  scope :with_provider, ->(provider_slug = nil) { provider_slug ? joins(:providers).where(providers: { slug: provider_slug }) : nil }

  %w[void draft published disabled].each do |s|
    define_method "#{s}?" do
      status.eql?(s)
    end
  end

  def original_version?
    original_post_id.nil?
  end

  def siblings
    self.class.where.not(id: id).where(original_post_id: original_post_id).or(self.class.where(id: original_post_id))
  end

  def versions
    original_version? ? localized_versions : siblings
  end

  def content_changed?
    content_fingerprint_changed? && published_at.present?
  end

  def publish!
    now = Time.now
    if may_change_to_published?
      if draft?
        self.published_at = now
        self.content_changed_at = now
      end
      self.status = 'published'
      save!
    end
  end

  def disable!
    update(status: 'disabled') if published?
  end

  def render_body
    @processor = HTMLMagicCommentProcessor.new(self)
    @processor.render
  end

  private

  def untouched?
    new_record? && void?
  end

  def may_change_to_draft?
    persisted? && void?
  end

  def may_change_to_published?
    disabled? || draft?
  end

  def set_content_changed_at
    self.content_changed_at = Time.now
  end

  def body_content
    strip_tags(body).strip.squeeze(' ').downcase
  end

  def set_content_fingerprint
    new_fingerprint = Digest::MD5.hexdigest(body_content)
    self.content_fingerprint = new_fingerprint if content_fingerprint != new_fingerprint
  end

  class HTMLMagicCommentProcessor
    include ActionView::Helpers::AssetTagHelper

    def initialize(post)
      @post = post
    end

    # Place a HTML magic comment directly in your html to translate a model to a html tag
    # <!-- #[tag]:[model_id]:[options] -->
    # entity    - valid html tag. Must implement render_[tag]_template method. Supported tag: img
    # model_id: - a record id
    # options:  - options as url params. Options will be passed to the render_[tag]_template method
    # i.e: <!-- #img:1:thumbor[width]=10&thumbor[height]=20 -->
    def render
      @post.body.gsub(/(<!-- #(img):([a-z0-9\-_]*):?(.*)? -->)/) do |_match|
        entity = Regexp.last_match(2)
        entity_id = Regexp.last_match(3)
        options = Rack::Utils.parse_nested_query(URI.encode(Regexp.last_match(4))).deep_symbolize_keys
        send(:"render_#{entity}_template", entity_id, options)
      end
    end

    private

    def render_img_template(entity_id, options)
      image = @post.images.find(entity_id)
      default_html_opts = { alt: image.caption }
      default_thumbor_opts = { width: 728 }
      image_tag(image.thumbor.file_url(default_thumbor_opts.merge(options[:thumbor] || {})), default_html_opts.merge(options[:html] || {}))
    end
  end
end
