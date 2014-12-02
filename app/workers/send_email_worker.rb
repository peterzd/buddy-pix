class SendEmailWorker
  include Sidekiq::Worker

  def perform(sender_id, card_id, to_url, content, email_host)
    sender = User.find sender_id
    card = Album.find card_id

    token = InvitationToken.generate_token(action: card, info: to_url, invitation_mode: InvitationToken::MODE[:email], inviter: sender)
    InvitationMailer.invite(sender, to_url, content, card, token, email_host).deliver
  end
end
