# == Schema Information
#
# Table name: invitation_tokens
#
#  id              :integer          not null, primary key
#  token           :string(255)
#  inviter_id      :integer
#  action_id       :integer
#  action_type     :string(255)
#  invitation_mode :string(255)
#  info            :string(255)
#  expired         :boolean          default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#

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
