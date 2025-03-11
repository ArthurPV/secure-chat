class CreateUserJtis < ActiveRecord::Migration[7.2]
  def change
    create_table :user_jtis do |t|
      t.timestamps
      t.string :jti, null: false
      t.references :user, null: false, foreign_key: true
    end
  end
end
