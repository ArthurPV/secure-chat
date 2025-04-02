class CreateUserContacteds < ActiveRecord::Migration[7.2]
  def change
    create_table :user_contacteds do |t|
      t.timestamps
      t.references :user_contact, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
    end
  end
end
