class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end



  private

  def user_params
    params.require(:user).permit(:name, :kana_name, :user_name, :email, :introduction, :age, :profile_image, :is_deleted)
  end
end
