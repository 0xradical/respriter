module IndexableByRobots
  extend ActiveSupport::Concern

  def indexable_by_robots?(locale=I18n.locale)
    indexable_by_robots_for_locale?(locale) || ignore_robots_noindex_rule || ENV.fetch("#{self.class.to_s.underscore.upcase}.IGNORE_ROBOTS_NOINDEX_RULE") { false }
  end

  def indexable_by_robots_for_locale?(locale)
    ignore_robots_noindex_rule_for.include? Locale.from_string(locale.to_s)
  end

  def ignore_robots_noindex_rule_for
    Locale.from_pg_array(super)
  end

end
