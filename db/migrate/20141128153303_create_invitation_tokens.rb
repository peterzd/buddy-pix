class CreateInvitationTokens < ActiveRecord::Migration
  def change
    create_table :invitation_tokens do |t|
      t.string :token
      t.references :inviter, index: true
      t.references :action, polymorphic: true, index: true
      t.string :invitation_mode # the values can only be within "email", and "sms"
      t.string :info # what the email is or the SMS is
      t.boolean :expired, default: false # defautl is false

      t.timestamps
    end
  end
end
