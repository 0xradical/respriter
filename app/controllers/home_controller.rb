class HomeController < ApplicationController

  def index
    @most_popular = Course.featured.locales([I18n.locale]).limit(8)
    @free_courses = Course.free.locales([I18n.locale]).limit(8)
  end

end
