class CourseTagger

  def initialize
    @tag_map = make_tag_map
  end

  def tag!(course)
    tags = search_tag_map(course.name)
    update_course!(course, tags)
  end

  def search_tag_map(course_name)
    [].tap do |found_tags|
      @tag_map.each do |tag, regex|
        found_tags << tag if regex.match(course_name)
      end
    end
  end

  protected
  def update_course!(course, tags)
    joined_tags = tags | (course.curated_tags || [])
    course.update(curated_tags: joined_tags)
  end

  def make_tag_map
    {}.tap do |tag_map|
      load_terms_from_file.each_pair do |tag, terms|
        escaped = terms.map { |t| '\b' + Regexp.escape(t) + '\b' }
        tag_map[tag] = /#{escaped.join('|')}/i
      end
    end
  end

  def load_terms_from_file
    YAML::load_file(Rails.root.join('config', 'tags_matching_terms.yml'))
  end
end
