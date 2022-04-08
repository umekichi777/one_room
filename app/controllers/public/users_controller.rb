class Public::UsersController < ApplicationController
  before_action :authenticate_customer!

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  private

  def user_params
    params.require(:user).permit(:name, :kana_name, :user_name, :email, :introduction, :age)
  end
end
