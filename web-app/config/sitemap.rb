SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
  ENV['AWS_S3_BUCKET_NAME'],
  {
    aws_endpoint:          ENV.fetch('AWS_S3_ENDPOINT'),
    aws_access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    aws_region:            ENV.fetch('AWS_S3_REGION')
  }
)

I18nHost.new('classpert.com').each do |locale, host|
  SitemapGenerator::Sitemap.default_host  = "https://#{host}"
  SitemapGenerator::Sitemap.sitemaps_host = "https://cdn.classpert.com"
  SitemapGenerator::Sitemap.public_path   = 'tmp/'
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{locale}"
  SitemapGenerator::Sitemap.create_index  = true
  SitemapGenerator::Sitemap.compress      = :all_but_first

  SitemapGenerator::Sitemap.create  include_root: false do

    add(root_path,                 { changefreq: 'weekly',  priority: 1 })
    add(privacy_policy_path,       { changefreq: 'yearly',  priority: 0.5})
    add(terms_and_conditions_path, { changefreq: 'yearly',  priority: 0.5})
    add(courses_path,              { changefreq: 'daily',   priority: 0.5})

    # Blog - Index
    add(posts_path, {
      changefreq: 'weekly',
      priority: 0.9,
      lastmod: Post.locale(I18nHelper.sanitize_locale(locale)).order(published_at: :desc).first&.published_at&.strftime('%Y-%m-%d')
    })
    # Blog - Post
    Post.locale(I18nHelper.sanitize_locale(locale)).published.each do |post|
      add(post_path(post.slug), { changefreq: 'monthly', priority: 0.9,  lastmod: post.content_changed_at })
    end

    # Bundle - Show
    Course.unnest_curated_tags.distinct.map {|c| c.tag.dasherize } .each do |tag|
      add(course_bundle_path(tag), {
        changefreq: 'weekly',
        priority: 1
      })
    end

    # Course - Show
    Course.joins(:provider).published.where("courses.slug IS NOT NULL").find_each do |course|
      if course.indexable_by_robots_for_locale?(locale)
        add(course_path(provider: course.provider.slug, course: course.slug), {
          changefreq: 'weekly',
          priority: 0.8
        })
      end
    end

    # Orphaned Profile - Index
    add(instructors_path, {
      changefreq: 'monthly',
      priority: 0.9,
      lastmod: OrphanedProfile.enabled.order(updated_at: :desc).first.updated_at.strftime('%Y-%m-%d')
    })

    # Orphaned Profile - Show
    OrphanedProfile.vacant.find_each do |orphaned_profile|
      add(orphaned_profile_path(orphaned_profile.slug), {
        changefreq: 'weekly',
        priority: 0.8
      })
    end

    Profile.instructor.publicly_listable.find_each do |profile|
      add(user_account_path(profile.username), {
        changefreq: 'monthly',
        priority: 0.7
      })
    end

  end
end
