class RemoveStreamKeyFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :stream_key, :string
  end
end
