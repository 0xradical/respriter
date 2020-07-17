# frozen_string_literal: true

class CourseBundlesController < ApplicationController
  include CourseSearchHelper
  include JapaneseHelper

  PER_PAGE = 75

  prepend_before_action :normalize_params

  def index
    bundles = Course.count_by_bundle(@tag)
    RootTag.all.each { |rt| bundles.delete rt.id }
    @bundles = bundles
    @bundles_by_letter = (I18n.locale == :ja) ? japanese_collation(bundles) : collate(bundles)
  end

  def show
    @courses, @root_tags = search

    respond_to do |format|
      format.html do
        if @root_tags.empty?
          raise ActionController::RoutingError, "No courses bundles for the term #{@tag}"
        end
      end

      format.json do
        render json: @courses
      end
    end
  end

  protected

  def collate(bundles)
    bundles.map { |k, v| [t("tags.#{k}"), { tag: k, count: v }] }
                .to_h.sort_by { |k, _v| k.downcase }.group_by { |k, _v| k[0].downcase }.map { |_k, v| Hash[v] }
  end

  def japanese_index_hash(k,v)
    reading = convert_to_kana(t("tags.#{k}"))
    { reading: reading, index: gojuon_index(reading), tag: k, count: v }
  end

  def japanese_collation(bundles)
    bundles.map { |k, v| [t("tags.#{k}"), japanese_index_hash(k,v)] }
                .to_h.sort_by { |_k, v| v[:reading].downcase }.group_by { |_k, v| v[:index] }.map { |_k, v| Hash[v] }
  end


  def search
    search_query_params[:per_page] ||= PER_PAGE
    search = Search::CourseSearch.new search_query_params
    tracker = SearchTracker.new(session_tracker, search, action: :course_bundle_search).store!
    root_tags = search.results[:meta][:aggregations][:curated_root_tags].values.map do |results|
      results.map(&:first)
    end.flatten.compact.uniq.map(&:to_s)

    [
      format_aggregations(tracker.tracked_results),
      root_tags
    ]
  end

  def search_query_params
    @search_query_params ||= {
      query:      search_params[:q],
      filter:     (search_params[:filter] || {}).merge(curated_tags: [@tag]),
      page:       search_params[:p],
      session_id: session_tracker.session_payload[:id],
      boost:      {
        browser_languages: browser_languages
      }
    }.merge(search_order_params)
  end

  def normalize_params
    @tag = params[:tag]&.downcase&.underscore
  end

  def search_order_params
    if search_params[:order].present?
      { order: search_params[:order].to_h.to_a }
    else
      {}
    end
  end
end
