require 'securerandom'

class InvitationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:accept]

  def new
    @invitation = Invitation.new
  end

  def index
    @invitation = current_user.groups.find(params[:group_id]).invitations
  end

  def show
    @invitation = Invitation.find(params[:id])
  end

  def create
    puts params.inspect

    @invitation = Invitation.new(params[:invitation])
    @group = current_user.groups.find(params[:group_id])

    #if @invitee = User.where().first
    if @invitee = User.where(:email => @invitation.email).first
      @invitation.user = @invitee
      @invitation.group = @group
      @invitation.code = SecureRandom.uuid
      @invitation.inviter = current_user.username

      if @invitation.save
        redirect_to(@user, :notice => 'Invitation sent.')
      else
        render :action => 'new', :error => 'Something went wrong'
      end
    else
      render :action => 'new', :error => 'No user with that email'
    end
  end

  def destroy
    Invitation.find(params[:id]).destroy
    redirect_to root_path
  end

  def accept
    @invitation = Invitation.find(params[:id])

    if current_user == @invitation.user
      @group = @invitation.group

      if @group.users << current_user
        @invitation.destroy
        redirect_to(current_user, :notice => 'Invitation accepted.')
      else
        redirect_to(current_user, :error => 'Something went wrong.')
      end
    end
  end
end
