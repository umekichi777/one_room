class Public::PostsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_q, only: [:index, :search]

  def new
    @post = Post.new
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # 受け取った値を , で区切って配列にする
    tag_list = params[:post][:tag_ids].split(',')
    if @post.save
      @post.save_tags(tag_list)
      flash[:notice] = "投稿しました！"
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end

  def index
    @posts = Post.all
    @tag_list = Tag.all
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
    @post = Post.find(params[:id])
    if params[:post] [:image_ids]
      params[:post] [:image_ids].each do |image_id|
        image = @post.images.find(image_id)
        image.purge
      end
    end
    tag_list = params[:post][:tag_ids].split(',')
    if @post.update(post_params)
      @old_relations = PostTag.where(post_id: @post.id)
      @old_relations.each do |relation|
        relation.delete
      end
      @post.save_tags(tag_list)
      flash[:notice] = "投稿を編集しました！"
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました！"
    redirect_to posts_path
  end

  def search
    @results = @q.result
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

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path
    end
  end

end
