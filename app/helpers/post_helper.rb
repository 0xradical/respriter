module PostHelper

  def publication_time(post)
    published_on, content_changed_on = post.published_at.to_date, post.content_changed_at&.to_date

    html = content_tag(:span) do
      l(published_on, format: :long)
    end

    if (content_changed_on)
      if (content_changed_on > published_on)
        html += content_tag(:span) do
          l(content_changed_on, format: :long)
        end
      end
    end

    html
  end

end
