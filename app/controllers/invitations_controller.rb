class InvitationsController < ApplicationController
  def new
    @users = User.where(type: nil).where.not(id: current_user.id)
  end

  def create
    user_ids = params[:user_ids]
    card = Album.find params[:card_id]
    user_ids.each do |id|
      current_user.send_invitation id, card
    end

    redirect_to card_path(card)
  end
end
