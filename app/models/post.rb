class Post < ApplicationRecord

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

  belongs_to  :original_version,    class_name: :Post, foreign_key: :original_post_id, optional: true
  has_many    :localized_versions,  class_name: :Post, foreign_key: :original_post_id

  belongs_to  :admin_account

  scope :tags,      -> (tags=nil) {  where("tags @> ARRAY[?]::varchar[]", tags) unless tags.nil? }
  scope :published, -> { where(status: 'published') }
  scope :locale,    -> (locale) { where(locale: locale) }
  scope :versions,  -> (id) { where(original_post_id: id).or(where(id: id)) }
  scope :originals, -> { where(original_post_id: nil) }

  %w(void draft published disabled).each do |s|
    define_method "#{s}?" do
      status.eql?(s)
    end
  end

  def original_version?
    original_post_id.nil?
  end

  def versions
    self.class.versions(original_post_id).where.not(id: id)
  end

  def sibling_versions
    self.class.where(original_post_id: original_post_id)
  end

  def content_changed?
    content_fingerprint_changed? && published_at.present?
  end

  def publish!
    now = Time.now
    if may_change_to_published?
      self.published_at, self.content_changed_at = now, now if draft?
      self.status = 'published'
      save!
    end
  end

  def disable!
    update(status: 'disabled') if published?
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
    if content_fingerprint != new_fingerprint
      self.content_fingerprint = new_fingerprint
    end
  end

end
