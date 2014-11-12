class InvitationsController < ApplicationController
  def new
    @users = User.where(type: nil)
  end
end
