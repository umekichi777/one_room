class Admin::GroupsController < ApplicationController
  before_action :set_q, only: [:index, :search]

  def index
    @groups = Group.page(params[:page])
  end

  def show
    @group = Group.find(params[:id])
  end

  def search
    @results = @q.result.page(params[:page])
  end



  private

  def set_q
    @q = Group.ransack(params[:q])
  end

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end
end
