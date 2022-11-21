class CreateSupportTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :support_tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :note

      t.timestamps
    end
  end
end
