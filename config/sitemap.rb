I18nHost.new('classpert.com').each do |locale, host|
  SitemapGenerator::Sitemap.default_host  = "https://#{host}"
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{locale}"
  SitemapGenerator::Sitemap.create_index  = :auto
  SitemapGenerator::Sitemap.create include_root: false do

    add(root_path,                 { changefreq: 'weekly',  priority: 1 })
    add(privacy_policy_path,       { changefreq: 'yearly',  priority: 0.5})
    add(terms_and_conditions_path, { changefreq: 'yearly',  priority: 0.5})
    add(courses_path,              { changefreq: 'daily',   priority: 0.5})

    # Blog
    add(posts_path, {
      changefreq: 'weekly',
      priority: 0.9,
      lastmod: Post.locale(I18nHelper.sanitize_locale(locale)).order(published_at: :desc).first&.published_at&.strftime('%Y-%m-%d')
    })
    Post.locale(I18nHelper.sanitize_locale(locale)).published.each do |post|
      add(post_path(post.slug), { changefreq: 'monthly', priority: 0.9,  lastmod: post.content_changed_at })
    end

    # Bundles
    Course.unnest_curated_tags.distinct.map {|c| c.tag.dasherize } .each do |tag|
      add(course_bundle_path(tag), {
        changefreq: 'weekly',
        priority: 1
      })
    end

    # Courses
    Course.joins(:provider).published.where("courses.slug IS NOT NULL").find_each do |course|
      course_slug = course.slug.gsub(/\A#{course.provider.slug}-(.*)/, '\1')
      add(course_path(provider: course.provider.slug, course: course_slug), {
        changefreq: 'weekly',
        priority: 0.8
      })
    end

  end
end
