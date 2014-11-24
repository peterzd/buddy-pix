class InvitationMailer < ActionMailer::Base
  default from: "buddypix.info@gmail.com"

  def invite(sender, to_url, content=nil, card)
    @user = sender
    @content = content || "I would like to invite you on BuddyPix to check our latest Card and Images. Please click on this link to access:"
    @card = card
    mail(to: to_url, subject: "Invite you to BuddyPix")
  end
end