class AddStreamKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stream_key, :string
  end
end
