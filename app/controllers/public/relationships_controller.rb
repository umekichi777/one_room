class Public::RelationshipsController < ApplicationController
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  # フォロー 一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  # フォロワー 一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
