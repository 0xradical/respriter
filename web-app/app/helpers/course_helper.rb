# frozen_string_literal: true

module CourseHelper
  def render_course_sharing(course, left: false, root_classes: [], run_context: self)
    render_component 'CourseSharing',
                     {
                       course:      course.as_indexed_json.slice(:id, :url, :name, :curated_tags),
                       version:     '2',
                       callOut:     t('.share.callout'),
                       linkText:    t('.share.link.copy'),
                       copiedText:  t('.share.link.copied'),
                       left:        left,
                       url:         Rails.application.routes.url_helpers.course_url(@course.provider.slug, @course.slug, host: ENV['CLASSPERT_URL']),
                       rootClasses: root_classes,
                       locale:      I18n.locale
                     },
                     run_context: run_context
  end
end
