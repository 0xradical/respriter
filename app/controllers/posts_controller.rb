class PostsController < ApplicationController

  def index
    @posts = Post.published.locale(I18n.locale)
    .tags(params[:tags]).page(params[:page]).order(published_at: :desc)
  end

  def show
    @post = Post.published.find_by!(slug: params[:id])
    @all_versions = Hash[[@post, @post.versions].compact.flatten.map do |post|
      [post.locale, post.slug]
    end]
  end

end
