module Api
  module Admin
    module V2

      class PostsController < ActionController::API

        def index
          @posts = Post.order(created_at: :desc).page(params[:p]).per(params[:_limit])
          options = { meta: { count: @posts.total_count } }
          render json: PostSerializer.new(@posts, options)
        end

        def new
          @post = current_admin_account.posts.void
          render json: PostSerializer.new(@post)
        end

        def show
          @post = Post.find(params[:id])
          render json: PostSerializer.new(@post)
        end

        def edit
          @post = Post.find(params[:id])
          render json: PostSerializer.new(@post)
        end

        def update
          @post = Post.find(params[:id])
          if @post.void?
            if @post.save_as_draft(post_params)
              render json: PostSerializer.new(@post)
            else
              render json: ErrorSerializer.new(@post), status: 422 
            end
          else
            @post.update(post_params)
          end
        end

        def destroy
          @post = Post.find(params[:id])
          @post.destroy!
          render json: PostSerializer.new(@post)
        end

        def publish
          @post = Post.find(params[:id])
          @post.publish!
          render json: PostSerializer.new(@post)
        end

        def unpublish
          @post = Post.find(params[:id])
          @post.draft!
          render json: PostSerializer.new(@post)
        end

        private

        def post_params
          params.require(:post).permit(:title, :body, :slug, :locale, tags: [], meta: {})
        end

      end

    end
  end
end

