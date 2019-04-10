class CoursesController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        @results = Course.search(query: search_params[:q], filter: search_params[:filter], order:
                                 search_params[:order]).page(params[:p]).results
        render json: {
          data: @results.map(&:_source),
          meta: {
            total: @results.total,
            aggregations: @results.response.aggregations,
          }
        }
      end
    end
  end

  def search_params
    params.permit(:q, order: {}, filter: {})
  end
end
