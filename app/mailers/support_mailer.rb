class SupportMailer < ActionMailer::Base
  default from: "buddypix.info@gmail.com"

  def support_email(support)
    to_email = "brian@buddypix.net"
    @support = support
    mail(to: to_email, subject: "new support email")
  end
end
