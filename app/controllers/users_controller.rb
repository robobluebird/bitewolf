class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
    @invites = Invitation.where(user: @user).all
  end
end
