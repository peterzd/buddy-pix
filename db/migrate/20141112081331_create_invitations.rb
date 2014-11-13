class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :sender, index: true
      t.references :receiver, index: true
      t.string :status
      t.references :card, index: true

      t.timestamps
    end
  end
end
