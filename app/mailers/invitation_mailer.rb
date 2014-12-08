class InvitationMailer < ActionMailer::Base
  default from: "buddypix.info@gmail.com"

  def invite(sender, to_url, content=nil, card, token, email_host)
    host = email_host
    @user = sender
    @content = content || "I would like to invite you on BuddyPix to check our latest Card and Images. Please click on this link to access:"
    @card = card
    @link_url = "http://#{host}/users/sign_in?invitation_token=#{token}"

    mail(to: to_url, subject: "Invitation to BuddyPix")
  end
end
