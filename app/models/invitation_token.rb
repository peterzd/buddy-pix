class InvitationToken < ActiveRecord::Base
  MODE = { email: "email", sms: "sms" }

  belongs_to :inviter, class_name: "User"
  belongs_to :action, polymorphic: true

  validates :invitation_mode, inclusion: { in: %w(email sms),
    message: "%{value} is not a valid type" }

  class << self
    def generate_token(options)
      token = SecureRandom.base64(10)
      create options.merge(token: token)
      token
    end
  end

  def expire
    update expired: true
  end
end
