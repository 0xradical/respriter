module DeviseHelper
  def devise_error_messages!
    return '' unless devise_error_messages?

    messages =
      resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div class='el:m-alert el:m-alert--error' style='margin-bottom:20px' id="error_explanation">
      <ul class='el:m-list el:m-list--unstyled'>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end
end
