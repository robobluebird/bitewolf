class GroupsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def index
    @groups = current_user.groups
  end

  def show
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])
    @group.users.push(current_user)

    if @group.save
      redirect_to(@group, :notice => 'Created.')
    else
      render :action => "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to(@group, :notice => 'Updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    Group.find(params[:id]).destroy
    redirect_to :action => "index"
  end

  def invite
  end

  def send_invitation
  end
end
