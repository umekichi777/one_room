class Admin::UsersController < ApplicationController
  before_action :set_q, only: [:index, :search]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def search
    @results = @q.result
  end



  private

  def set_q
    @q = User.ransack(params[:q])
  end

  def user_params
    params.require(:user).permit(:name, :kana_name, :user_name, :email, :introduction, :age, :profile_image, :is_deleted)
  end
end
