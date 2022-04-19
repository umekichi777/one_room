class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_q, only: [:index, :search]

  def new
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      flash[:notice] = "グループを作成しました！"
      redirect_to group_path(@group.id)
    else
      render 'new'
    end
  end

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      flash[:notice] = "グループを編集しました！"
      redirect_to group_path(@group.id)
    else
      render 'edit'
    end
  end

  def all_destroy
    @group = Group.find(params[:group_id])
    if @group.destroy
      flash[:notice] = "グループを削除しました！"
      redirect_to groups_path
    end
  end

  # グループに参加
  def join
    @group = Group.find(params[:group_id])
    @group.users << current_user
    flash[:notice] = "参加しました！"
    redirect_to  groups_path
  end

  # グループから退会
  def destroy
    @group = Group.find(params[:id])
    #current_userは、@group.usersから消されるという記述
    @group.users.delete(current_user)
    flash[:notice] = "退会しました！"
    redirect_to groups_path
  end

  def search
    @results = @q.result
  end



  private

  def set_q
    @q = Group.ransack(params[:q])
  end

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
