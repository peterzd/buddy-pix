# == Schema Information
#
# Table name: supports
#
#  id          :integer          not null, primary key
#  sender_name :string(255)
#  email       :string(255)
#  subject     :string(255)
#  message     :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Support < ActiveRecord::Base
end
