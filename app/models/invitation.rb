class Invitation < ActiveRecord::Base
  STATUS = { pending: "pending", accepted: "accepted", rejected: "rejected" }

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :card, class_name: "Album"
end
