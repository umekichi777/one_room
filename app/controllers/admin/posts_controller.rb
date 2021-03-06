class Admin::PostsController < ApplicationController
  before_action :set_q, only: [:index, :search]

  def index
    @posts = Post.page(params[:page])
    @tag_list = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    # コメントを最新順に表示
    @post_comments = @post.post_comments.order(created_at: :desc)
    @post_tags = @post.tags
  end

  def search
    @results = @q.result.page(params[:page])
  end

  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.all
  end



  private

  def set_q
    @q = Post.ransack(params[:q])
  end

  def post_params
    params.require(:post).permit(:title, :body, :user_id, images: [ ])
  end

end
