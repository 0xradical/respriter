# frozen_string_literal: true

class OrphanedProfileSerializer
  include FastJsonapi::ObjectSerializer
  extend ActionView::Helpers::AssetUrlHelper
  extend Minipack::Helper
  set_key_transform :camel_lower

  attributes :name, :teaching_subjects,
             :teaching_at, :avatar_url, :website

  attribute :subject do |object|
    subject(object)
  end

  attribute :slug do |object|
    object.respond_to?(:slug) ? object.slug : object.username
  end

  attribute :profile_path do |object|
    Rails.application.routes.url_helpers.orphaned_profile_path(object.slug)
  end

  attribute :subject_image_url do |object|
    asset_bundle_path('media/images/' + subject(object) + '.jpg') if subject(object)
  end

  attribute :course_count do |object|
    object.courses.count
  end

  class << self
    def subject(object)
      (object.teaching_subjects & RootTag.all.map(&:id))&.first
    end
  end

  def self.to_proc
    ->(object) { new(object).serializable_hash.dig(:data, :attributes) }
  end
end
