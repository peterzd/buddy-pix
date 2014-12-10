class InvitationsService
  def initialize(invitation)
    @invitation = invitation
  end

  class << self
    def send_email(sender, card, to_url, content, email_host)
      to_url.split(",").each do |url|
        u = url.strip
        SendEmailWorker.perform_async sender.id, card.id, u, content, email_host
      end
    end
  end
end
