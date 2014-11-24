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

  def invite_by_email
    card = Album.find params[:card_id]
    to_url = email_params[:to_url]
    content = email_params[:content]
    InvitationMailer.invite(current_user, to_url, content, card).deliver

    redirect_to card_path(card)
  end

  private
  def email_params
    params.require(:email).permit(:to_url, :content)
  end
end
