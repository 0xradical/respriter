# frozen_string_literal: true

class ProviderCoursesController < CoursesController
  def index
    @provider = Provider.slugged.find_by(slug: params[:provider])
    super
  end
end
