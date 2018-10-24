class CoursesController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json do
        @results = Course.search(params[:q], load_filters).page(params[:p]).results
        render json: { data: @results.map(&:_source), meta: { total: @results.total, aggregations: @results.response.aggregations }}
      end
    end
  end

  def load_filters
    category = params[:category].present? ? [params[:category]&.gsub('-','_')] : params[:categories]
    {
      category: category,
      audio: params[:audio],
      subtitles: params[:subtitles],
      price: params[:price]
    }
  end

end
