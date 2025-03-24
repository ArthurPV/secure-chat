class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.timestamps
      t.text :content, null: false
    end
  end
end
