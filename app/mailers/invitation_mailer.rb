class InvitationMailer < ActionMailer::Base
  default from: "buddypix.info@gmail.com"

  def invite(sender, to_url, content=nil, card, token, email_host)
    host = email_host
    @user = sender
    @content = content || "Hi, #{sender.user_name} has sent you an invitation to join BuddyPix, a new interest-based social platform.  You can click on the link below to accept their invitation and create an account"
    @card = card
    @link_url = "http://#{host}/users/sign_in?invitation_token=#{token}"

    mail(to: to_url, subject: "Invitation to BuddyPix")
  end
end
