class HomeController < ApplicationController

  def index
    @most_popular = Course.featured.limit(8)
    @free_courses = Course.free.limit(8)
  end

end
