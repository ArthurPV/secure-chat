class CreateUserContacts < ActiveRecord::Migration[7.2]
  def change
    create_table :user_contacts do |t|
      t.integer :status, null: false, default: 0
      t.uuid :uuid, default: -> { "gen_random_uuid()" }, null: false
      t.timestamps
    end
  end
end
