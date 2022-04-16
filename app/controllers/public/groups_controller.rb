class Public::GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to group_path(@group.id)
    else
      render 'new'
    end
  end

  def index
  end

  def show
  end

  def edit
  end
  
  
  private
  
  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end
end
