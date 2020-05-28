# frozen_string_literal: true

class OrphanedProfile < ApplicationRecord
  class IdentityMismatchError < StandardError
    def initialize(data)
      super(I18n.t(:identity_mismatch, { scope: %i[activerecord errors models orphaned_profiles] }.merge(data)))
    end
  end

  include Slugifyable
  slugify run_on:           :before_save,
          callback_options: { unless: -> { slug.present? } }

  scope :enabled,           -> { where(state: 'enabled') }
  scope :vacant,            -> { enabled.where('claimed_by IS NULL') }
  scope :with_slug,         -> { where.not(slug: nil) }
  scope :teaching_subjects, ->(subjects) { where('teaching_subjects @> ARRAY[?]::varchar[]', subjects) }

  after_initialize :reset_code_claim_process!, if: :claim_has_expired?

  def claim_has_expired?
    Time.now > claim_code_expires_at if claim_code_expires_at
  end

  def has_been_successfully_claimed?
    !!claimed_by
  end

  def reset_code_claim_process!
    update(claim_code: nil)
  end

  def enabled?
    state == 'enabled'
  end

  def has_claimable_methods?
    claimable_emails.any? || claimable_public_profiles.any?
  end

  def transfer_ownership!(user_account)
    return if has_been_successfully_claimed?

    transaction do
      profile = user_account.profile.tap do |p|
        p.public                  = true
        p.instructor              = true
        p.name                  ||= name
        p._name                 ||= name
        p.uploaded_avatar_url   ||= avatar_url
        p.long_bio              ||= long_bio
        p.short_bio             ||= short_bio
        p.teaching_subjects     ||= teaching_subjects
        p.course_ids              = course_ids
        p.save!
      end
      self.claimed_by = user_account.username
      self.claim_code = nil
      mark_as_destroyed!
    end

    begin
      user_account.profile.website ||= "http:#{website}"
      user_account.profile.save!
    rescue ActiveRecord::StatementInvalid
      user_account.profile.reload
    end

    social_profiles.each do |k, v|
      user_account.profile.social_profiles.merge!(Hash[k, "https:#{v}"])
      user_account.profile.save!
    rescue ActiveRecord::StatementInvalid
      user_account.profile.reload
      puts "Error #{k}, #{v}"
      next
    end

    elearning_profiles.each do |k, v|
      user_account.profile.elearning_profiles.merge!(Hash[k, "https:#{v}"])
      user_account.profile.save!
    rescue ActiveRecord::StatementInvalid
      user_account.profile.reload
      puts "Error #{k}, #{v}"
      next
    end
  end

  def courses
    Course.where(id: course_ids).limit(50)
  end

  def self.courses_by_instructor_name(name)
    query = <<-SQL
    WITH
    A AS (
    SELECT
      id
      ,jsonb_array_elements(instructors) AS instructor
    FROM courses
    )
    SELECT *
    FROM A
    WHERE (instructor->>'name') = '#{name}';
    SQL
    ActiveRecord::Base.connection.execute(query)
  end

  def generate_claim_code!(expires_after = 1.hour)
    self.claim_code ||= SecureRandom.hex(24)
    self.claimed_at             = Time.now
    self.claim_code_expires_at  = claimed_at + expires_after
    save!
  end

  def masked_claimable_emails
    Hash[claimable_emails.map do |email|
      handler, domain = email.split('@')
      mask = [handler, domain].map do |chunk|
        chunk.split('').map.each_with_index do |c, i|
          i > (handler.length - (handler.length * 0.9)).ceil ? '*' : c
        end.join
      end.join('@')
      [mask, email]
    end]
  end

  def mark_as_destroyed!
    self.marked_as_destroyed_at = Time.now + 6.months
    save!
  end

  def elearning_profiles
    public_profiles.select do |k|
      %w[pluralsight skillshare linkedin_learning udemy treehouse masterclass platzi].include?(k)
    end
  end

  def social_profiles
    public_profiles.reject { |k| elearning_profiles.keys.include?(k) }
  end

  %w[github twitter facebook linkedin].each do |provider|
    define_method "#{provider}_nickname" do
      claimable_public_profiles[provider]&.send(:[], 'nickname')
    end
  end

  def facebook_uid
    claimable_public_profiles['facebook']['uid']
  end

  def verify_github_identity!(oauth_data)
    unless github_nickname == oauth_data['info']['nickname']
      raise IdentityMismatchError.new({
                                        provider:          'Github',
                                        canonical_handler: github_nickname
                                      })
    end
  end

  def verify_twitter_identity!(oauth_data)
    unless twitter_nickname == oauth_data['info']['nickname']
      raise IdentityMismatchError.new({
                                        provider:          'Twitter',
                                        canonical_handler: twitter_nickname
                                      })
    end
  end

  def verify_facebook_identity!(oauth_data)
    unless facebook_uid == oauth_data['info']['uid']
      raise IdentityMismatchError.new({
                                        provider:          'Facebook',
                                        canonical_handler: facebook_nickname
                                      })
    end
  end

  def verify_linkedin_identity!(oauth_data)
    unless linkedin_nickname == oauth_data['info']['vanityName']
      raise IdentityMismatchError.new({
                                        provider:          'Linkedin',
                                        canonical_handler: linkedin_nickname
                                      })
    end
  end
end
