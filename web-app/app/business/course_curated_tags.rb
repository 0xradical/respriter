class CourseCuratedTags

  def initialize(course)
    @course = course
  end

  def curated_tags
    @current_version ||= self.current_version
    @current_version&.curated_tags || []
  end

  def excluded_tags
    @current_version ||= self.current_version
    @current_version&.excluded_tags || []
  end

  def add_tag(tag, author)
    new_tags_lists = add_curated_tag_to_list(tag)
    change_tags(new_tags_lists.merge({ author: author }))
  end

  def exclude_tag(tag, author)
    new_tags_lists = exclude_curated_tag_from_list(tag)
    change_tags(new_tags_lists.merge({ author: author }))
  end

  def roll_back_tags(max_timestamp)
    target_version = first_version_older_than(max_timestamp)
    return false if target_version.nil?

    change_tags({
      curated_tags: target_version.curated_tags,
      excluded_tags: target_version.excluded_tags,
      author: 'rollback'
    })
  end

  protected
  def add_curated_tag_to_list(tag)
    if excluded_tags.include?(tag)
      tags_lists
    else
      tags_lists.merge({ curated_tags: curated_tags | [tag] })
    end
  end

  def exclude_curated_tag_from_list(tag)
    {
      curated_tags: curated_tags - [tag],
      excluded_tags: excluded_tags | [tag]
    }
  end

  def tags_lists
    {
      curated_tags: curated_tags,
      excluded_tags: excluded_tags
    }
  end

  def change_tags(new_version_params)
    return false if new_version_params.except(:author) == tags_lists

    @current_version = nil
    safe_create_current_version(new_version_params)
  end

  def safe_create_current_version(params)
    ActiveRecord::Base.transaction do
      demote_all_versions
      create_current_version(params)
    end
  end

  def current_version
    CuratedTagsVersion.where(course: @course, current: true).first
  end

  def demote_all_versions
    CuratedTagsVersion.where(course: @course, current: true).update_all(current: false)
  end

  def create_current_version(params)
    CuratedTagsVersion.create(params.merge({ course: @course, current: true }))
  end

  def first_version_older_than(timestamp)
    CuratedTagsVersion.where(course: @course).where("created_at < ?", timestamp).order(created_at: :desc).first
  end
end
