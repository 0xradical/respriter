# frozen_string_literal: true

SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
  ENV['AWS_S3_BUCKET_NAME'],
  {
    aws_endpoint:          ENV.fetch('AWS_S3_ENDPOINT'),
    aws_access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    aws_region:            ENV.fetch('AWS_S3_REGION')
  }
)

I18n.available_locales.each do |locale|
  SitemapGenerator::Sitemap.default_host  = "https://#{Domain.new.route_for(locale)}"
  SitemapGenerator::Sitemap.sitemaps_host = "https://cdn.classpert.com"
  SitemapGenerator::Sitemap.public_path   = 'tmp/'
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{locale.to_s.downcase}"
  SitemapGenerator::Sitemap.create_index  = true
  SitemapGenerator::Sitemap.compress      = :all_but_first

  SitemapGenerator::Sitemap.create include_root: false do
    add(root_path,                 { changefreq: 'weekly',  priority: 1 })
    add(privacy_policy_path,       { changefreq: 'yearly',  priority: 0.5 })
    add(terms_and_conditions_path, { changefreq: 'yearly',  priority: 0.5 })
    add(courses_path,              { changefreq: 'daily',   priority: 0.5 })

    # Blog - Index
    add(posts_path, {
          changefreq: 'weekly',
          priority:   0.9,
          lastmod:    Post.locale(I18nHelper.sanitize_locale(locale)).order(published_at: :desc).first&.published_at&.strftime('%Y-%m-%d')
        })

    # Blog - Post
    Post.locale(I18nHelper.sanitize_locale(locale)).published.each do |post|
      add(post_path(post.slug), { changefreq: 'monthly', priority: 0.9,  lastmod: post.content_changed_at&.strftime('%Y-%m-%d') })
    end

    # Bundle - Show
    Course.unnest_curated_tags.distinct.map { |c| c.tag.dasherize } .each do |tag|
      add(course_bundle_path(tag), {
        changefreq: 'weekly',
        lastmod: Time.now.strftime('%Y-%m-%d'),
        priority: 1
      })
    end

    # Course - Show
    Course.joins(:provider).published.where('courses.slug IS NOT NULL').find_each do |course|
      if course.indexable_by_robots?(locale)
        add(course_path(provider: course.provider.slug, course: course.slug), {
              changefreq: 'weekly',
              lastmod:    (ENV.fetch('FORCE_LASTMOD_FOR_COURSES') { false } ? Time.now : course.updated_at).strftime('%Y-%m-%d'),
              priority:   0.9
            })
      end
    end

    # Orphaned Profile - Index
    add(instructors_path, {
          changefreq: 'monthly',
          priority:   0.8,
          lastmod:    OrphanedProfile.enabled.order(updated_at: :desc).first.updated_at.strftime('%Y-%m-%d')
        })

    # Orphaned Profile - Show
    OrphanedProfile.vacant.with_courses.find_each do |orphaned_profile|
      if orphaned_profile.indexable_by_robots?(locale)
        add(orphaned_profile_path(orphaned_profile.slug), {
              changefreq: 'weekly',
              lastmod:    (ENV.fetch('FORCE_LASTMOD_FOR_ORPHANED_PROFILES') { false } ? Time.now : orphaned_profile.updated_at).strftime('%Y-%m-%d'),
              priority:   0.8
            })
      end
    end

    Profile.instructor.publicly_listable.find_each do |profile|
      add(user_account_path(profile.username), {
            changefreq: 'weekly',
            lastmod:    (ENV.fetch('FORCE_LASTMOD_FOR_PROFILES') { false } ? Time.now : profile.updated_at).strftime('%Y-%m-%d'),
            priority:   0.8
          })
    end

    if ENV.fetch('SITEMAP.PING_SEARCH_ENGINES') { false }
      SitemapGenerator::Sitemap.ping_search_engines
    end
  end
end
