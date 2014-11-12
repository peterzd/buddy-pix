class Invitation < ActiveRecord::Base
  belongs_to :sender
  belongs_to :invited_user
  belongs_to :card
end
