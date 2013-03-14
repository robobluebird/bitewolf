class LunchesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @lunch = Lunch.new
  end

  def index
    @lunches = current_user.groups.find(params[:group_id]).lunches
  end

  def show
    @group = current_user.groups.find(params[:group_id])
    @lunch = @group.lunches.find(params[:id]).sort_locations_by_upvotes!

    @lunch.tally
  end

  def create
    @lunch = Lunch.new(params[:lunch])
    @lunch.time_message = "Initial time (#{current_user.username})"
    @group = current_user.groups.find(params[:group_id])

    @location = Location.new(:restaurant => params[:restaurant], :style => params[:style])
    @location.upvotes = [current_user.id]
    @location.downvotes = []

    if @lunch.locations << @location && @group.lunches << @lunch
      redirect_to(@group, :notice => 'Created.')
    else
      render :action => "new"
    end
  end

  def update
    @group = current_user.groups.find(params[:group_id])
    @lunch = @group.lunches.find(params[:id])
    params[:lunch][:time_message] << " (#{current_user.username})"

    if @lunch.update_attributes(params[:lunch])
      redirect_to([@group, @lunch], :notice => 'Updated the time.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @group = current_user.groups.find(params[:group_id])
    @group.lunches.find(params[:id]).destroy
    redirect_to(@group, :notice => 'Deleted.')
  end
end
