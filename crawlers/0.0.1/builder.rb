# class CrawlerBuilder[0.0.1] < Integration::Napoleon::CrawlerBuilder::Base

def create_pipeline_templates!
  course_params = build_template_by_folder 'course'
  course_params[:name] = [provider.name, course_params[:name]].join ' '
  course_pipeline = add_pipeline_template course_params

  sitemap_params = build_template_by_folder 'sitemap'
  sitemap_params[:name] = [provider.name, sitemap_params[:name]].join ' '
  sitemap_params[:data].merge!(
    next_pipeline_template_id: course_pipeline[:id],
    provider_id: provider.id,
    provider_name: provider.name,
    crawler_id: provider_crawler.id,
    user_agent: { version: '1.0.0', token: provider_crawler.user_agent_token },
    sitemaps: verified_sitemaps,
    domains: verified_domains
  )
  add_pipeline_template sitemap_params
end

def create_pipeline_execution!
  sitemap_template = @pipeline_templates[-1]
  add_pipeline_execution(
    name: provider.name,
    run_at: Time.now,
    schedule_interval: '2 weeks',
    pipeline_template_id: sitemap_template[:id]
  )
end

def rollback!
  @pipeline_templates.each do |template|
    delete_pipeline_template template[:id]
  end
  @pipeline_templates = []
end

def cleanup
  provider_crawler.transaction do
    provider_crawler.settings[:pipeline_templates].each do |pipeline_template|
      delete_pipeline_template pipeline_template[:id]
    end

    provider_crawler.settings[:pipeline_executions]
      .each do |pipeline_execution|
      delete_pipeline_execution pipeline_execution[:id]
    end

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
  end.map(
    &:domain
  )
end

# end
