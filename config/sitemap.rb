I18nHost.new('classpert.com').each do |locale, host|
  SitemapGenerator::Sitemap.default_host  = "https://#{host}"
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{locale}"
  SitemapGenerator::Sitemap.create_index  = :auto
  SitemapGenerator::Sitemap.create include_root: false do

    add(root_path,                 { changefreq: 'weekly' })
    add(privacy_policy_path,       { changefreq: 'yearly' })
    add(terms_and_conditions_path, { changefreq: 'yearly' })
    add(courses_path,              { changefreq: 'daily'  })

    # Blog
    add(posts_path, {
      changefreq: 'weekly',
      lastmod: Post.locale(I18nHelper.sanitize_locale(locale)).order(published_at: :desc).first&.published_at&.strftime('%Y-%m-%d') 
    })
    Post.locale(I18nHelper.sanitize_locale(locale)).published.each do |post|
      add(post_path(post.slug), { changefreq: 'monthly', lastmod: post.content_changed_at })
    end

    # Bundles
    Course.unnest_curated_tags.distinct.map {|c| c.tag.dasherize } .each do |tag|
      add(course_bundle_path(tag), {
        changefreq: 'weekly',
        priority: 1
      })
    end

  end
end
