class HomeController < ApplicationController

  def index
    @count_by_category = Course.group('category').count
    #@providers    = Provider.joins(:courses).group('providers.name').having("COUNT(*) > 35").order('count_all DESC').limit(15).count
    @most_popular = Course.featured.locales([I18n.locale]).limit(8)
    @free_courses = Course.free.locales([I18n.locale]).limit(8)
  end

end
