module ErrorsHelper
  def error_messages!(resource)
    return '' unless error_messages?(resource)

    messages =
      resource.errors.full_messages.each_with_index.map do |msg, idx|
        if idx == resource.errors.size - 1
          content_tag(:li, msg, { style: "margin-bottom: 0;" })
        else
          content_tag(:li, msg)
        end
      end.join

    html = <<-HTML
    <div class='el:m-alert el:m-alert--error' style='margin-bottom:20px' id="error_explanation">
      <ul class='el:m-list el:m-list--unstyled'>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def error_messages?(resource)
    !resource.errors.empty?
  end
end
