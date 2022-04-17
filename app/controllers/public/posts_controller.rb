class Public::PostsController < ApplicationController
  def new
    @post = Post.new
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # 受け取った値を , で区切って配列にする
    tag_list = params[:post][:name].split(',')
    if @post.save
      @post.save_tag(tag_list)
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    # コメントを最新順に表示
    @post_comments = @post.post_comments.order(created_at: :desc)
    @post_tags = @post.tags
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def update
    post = Post.find(params[:id])
    if params[:post] [:image_ids]
      params[:post] [:image_ids].each do |image_id|
        image = post.images.find(image_id)
        image.purge
      end
    end
    tag_list=params[:post][:name].split(',')
    if post.update(post_params)
      @post.save_tag(tag_list)
      redirect_to post_path(post)
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :user_id, images: [ ])
  end
end
