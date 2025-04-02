class CreateUserContactRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :user_contact_requests do |t|
      t.references :user, foreign_key: true, null: false
      t.bigint :contacted_id, null: false
      t.uuid :uuid, default: -> { "gen_random_uuid()" }, null: false
      t.timestamps
    end
  end
end
