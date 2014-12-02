class InvitationsService
  def initialize(invitation)
    @invitation = invitation
  end

  class << self
    def send_email(sender, card, to_url, content, email_host)
      SendEmailWorker.perform_async sender.id, card.id, to_url, content, email_host
    end
  end
end
