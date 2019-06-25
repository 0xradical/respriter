class HomeController < ApplicationController

  def index
    @count_by_category = Course.group('category').count
  end

end
