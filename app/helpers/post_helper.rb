module PostHelper

  def content_changed_after_period?(post, period: 1.month)
    post.content_changed_at.to_date >= (post.published_at.to_date + period)
  end

end
