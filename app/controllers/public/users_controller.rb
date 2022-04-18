class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "アカウント編集しました！"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end
  
  def withdrawal
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会しました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :kana_name, :user_name, :email, :introduction, :age, :profile_image)
  end
end
