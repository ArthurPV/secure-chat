class CreateUserKeys < ActiveRecord::Migration[7.2]
  def change
    create_table :user_keys do |t|
      t.timestamps
      t.string :public_key, null: false
      t.string :private_key, null: false
    end
  end
end
