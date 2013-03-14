class LocationsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @location = Location.new
  end

  def index
  end

  def show
  end

  def create
    user_id = current_user.id
    @group = current_user.groups.find(params[:group_id])
    @lunch = @group.lunches.find(params[:lunch_id])
    @location = Location.new(params[:location])

    @location.suggester_id = user_id

    @lunch.remove_voter_upvotes! user_id
    @location.upvotes = [user_id]
    @location.downvotes = []

    if @lunch.locations << @location
      redirect_to([@group, @lunch], :notice => 'Created.')
    else
      render 'new'
    end
  end

  def vote
    @group = current_user.groups.find(params[:group_id])
    @lunch = @group.lunches.find(params[:lunch_id])
    @location = @lunch.locations.find(params[:id])
    voter = current_user.id

    if params[:vote] == "up"
      if !@location.upvotes.include? voter
        @lunch.remove_voter_upvotes! voter
        if @location.downvotes.include? voter
          @location.downvotes.delete(voter)
        end

        @location.upvotes << voter
      end
    else
      if !@location.downvotes.include? voter
        if @location.upvotes.include? voter
          @location.upvotes.delete(voter)
        end

        @location.downvotes << voter
      end
    end

    if @location.save
      @lunch.tally
      redirect_to([@group, @lunch], :notice => "Voted.")
    end
  end
end
