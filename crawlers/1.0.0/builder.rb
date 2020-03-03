# class CrawlerBuilder[1.0.0] < Integration::Napoleon::CrawlerBuilder

def pipeline_templates
  @pipeline_templates ||=
    provider_crawler.settings&.deep_symbolize_keys&.[](:pipeline_templates) ||
      []
end

def create_pipeline_templates!
  events_params = build_template_by_folder 'crawling_events'
  events_params[:name] = [provider.name, events_params[:name]].join ' '
  events_pipeline = add_pipeline_template events_params

  course_params = build_template_by_folder 'course'
  course_params[:name] = [provider.name, course_params[:name]].join ' '
  course_params[:data] = { next_pipeline_template_id: events_pipeline[:id] }
  course_pipeline = add_pipeline_template course_params

  sitemap_params = build_template_by_folder 'sitemap'
  sitemap_params[:name] = [provider.name, sitemap_params[:name]].join ' '
  sitemap_params[:data] = {
    next_pipeline_template_id: course_pipeline[:id],
    provider_id: provider.id,
    provider_name: provider.name,
    crawler_id: provider_crawler.id,
    user_agent: { version: '1.0.0', token: provider_crawler.user_agent_token },
    sitemaps: verified_sitemaps,
    domains: verified_domains
  }
  add_pipeline_template sitemap_params
end

def create_pipeline_execution!
  sitemap_template = pipeline_templates[-1]
  add_pipeline_execution(
    name: provider.name,
    run_at: Time.now,
    schedule_interval: '2 weeks',
    pipeline_template_id: sitemap_template[:id]
  )
end

def remove_pipeline_templates
  pipeline_templates.each { |template| delete_pipeline_template template[:id] }

  @pipeline_templates = []
end

def rollback!
  remove_pipeline_templates
end

def cleanup
  provider_crawler.transaction do
    remove_pipeline_templates

    provider_crawler.version = nil
    provider_crawler.settings = nil
    provider_crawler.save!
  end
end

def verified_sitemaps
  provider_crawler.sitemaps.find_all do |sitemap|
    sitemap[:status] == 'verified'
  end.map { |sitemap| sitemap[:url] }
end

def verified_domains
  provider_crawler.crawler_domains.find_all do |domain|
    domain.authority_confirmation_status == 'confirmed'
  end.map(&:domain)
end

def prepared?
  provider_crawler.version.present? && provider_crawler.settings.present?
end

def update_provider_crawler!
  provider_crawler.version = @version
  provider_crawler.settings = { pipeline_templates: pipeline_templates }
  provider_crawler.status = :active
  provider_crawler.save!
end

# end
