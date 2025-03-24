class DropEnumDestinationType < ActiveRecord::Migration[7.2]
  def up
    execute "DROP TYPE IF EXISTS destination_type;"
  end

  def down; end
end
