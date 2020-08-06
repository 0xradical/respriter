# frozen_string_literal: true

class Profile < ApplicationRecord
  has_many :used_username

  include Imageable::HasOne
  initialize_imageable_module :image

  belongs_to :user_account
  has_one :subscription, dependent: :nullify

  scope :instructor,        -> { where(instructor: true) }
  scope :is_public,         -> { where(public: true) }
  scope :publicly_listable, -> { is_public.where.not(username: nil) }

  def courses(limit = 50)
    result = Course.where(id: course_ids).published
    limit ? result.limit(limit) : result
  end

  def avatar_url
    uploaded_avatar_url || oauth_avatar_url
  end
end
