class HomeController < ApplicationController

  def index
    @most_popular = Course.order(relevance: :desc).limit(16)
    @free_courses = Course.free.limit(16)
  end

end
