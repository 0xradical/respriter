class CourseBundlesController < ApplicationController

  prepend_before_action :normalize_params
  before_action :load_bundles

  def index; end

  def show
    @course_bundle = Course.by_tags([@tag])
    @root_tags = (@course_bundle.map { |cb| cb.curated_tags  }.flatten & RootTag.all.map(&:id)).uniq
    respond_to do |format|
      format.html
      format.json  { render json: { data: @course_bundle.limit(75).map(&:as_indexed_json) } }
    end
  end

  private

  def load_bundles
    bundles  = Course.unnest_curated_tags(Course.by_tags(@tag)).group(:tag).count
    RootTag.all.each { |rt| bundles.delete(rt.id) }
    @bundles_by_letter = bundles.map { |k,v| [t("tags.#{k}"), { tag: k, count: v }]}.to_h.group_by { |k,v| k[0] }.sort.map { |k,v| Hash[v] }
  end

  def normalize_params
    @tag = params[:tag]&.underscore
  end

end
