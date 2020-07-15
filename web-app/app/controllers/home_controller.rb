class HomeController < ApplicationController

  def index
    @count_by_category = Course.group('category').count
    @courses_count = Course.published.count
    @providers_count = Provider.published.count
  end

end
