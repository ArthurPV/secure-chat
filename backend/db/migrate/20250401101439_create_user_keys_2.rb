class CreateUserKeys2 < ActiveRecord::Migration[7.2]
  def change
    create_table :user_keys do |t|
      t.string :public_key, null: false
      t.string :private_key, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
