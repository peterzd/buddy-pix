class InvitationsController < ApplicationController
  respond_to :html, :json

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

  def accept
    @invitation = Invitation.find params[:id]
    @invitation.accept
  end

  def reject
    @invitation = Invitation.find params[:id]
    @invitation.reject
  end

  def invite_by_email
    card = Album.find params[:card_id]
    to_url = email_params[:to_url]
    content = email_params[:content]
    email_host = request.host_with_port

    to_url_array = to_url.split(",")
    InvitationsService.send_email(current_user, card, to_url_array, content, email_host)

    redirect_to card_path(card)
  end

  private
  def email_params
    params.require(:email).permit(:to_url, :content)
  end
end
