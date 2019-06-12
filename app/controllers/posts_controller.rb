class PostsController < ApplicationController

  def index
    @posts = Post.published.locale(I18n.locale).tags(params[:tags]).page(params[:p]).order(created_at: :desc)
  end

  def show
    @post = Post.published.find_by(slug: params[:id])
  end

end
