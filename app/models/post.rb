class Post < ApplicationRecord

  include Imageable::HasMany
  include Slugifyable
  include ActionView::Helpers::TextHelper

  slugify :title, callback_options: { if: -> { slug.blank? }, unless: :void? }

  with_options unless: :void? do
    validates :title, :body,  presence: true
    before_save :save_content_fingerprint
    before_save :update_content_changed_at!, if: :content_changed?
  end

  belongs_to :admin_account 

  scope :tags,      -> (tags=nil) {  where("tags @> ARRAY[?]::varchar[]", tags) unless tags.nil? }
  scope :published, -> { where(status: 'published') }
  scope :locale,    -> (locale) { where(locale: locale) }

  %w(published draft void).each do |s|
    define_method "#{s}?" do
      status.eql?(s)
    end
  end

  def save_as_draft(attributes)
    if void?
      self.status = 'draft'
      update(attributes)
    end
  end

  def content_changed?
    content_fingerprint_changed? && published_at.present?
  end

  def update_content_changed_at!
    update_column(:content_changed_at, Time.now.utc)
  end

  def publish!
    update_columns(status: 'published', published_at: (self.published_at || Time.now.utc)) if draft?
  end

  def draft!
    update_column(:status, 'draft') if published?
  end

  private

  def generate_content_fingerprint
    Digest::MD5.hexdigest(strip_tags(body))
  end

  def save_content_fingerprint
    fingerprint = generate_content_fingerprint
    self.content_fingerprint = fingerprint if (content_fingerprint != fingerprint)
  end

end
