class RemoveUserIdFromVods < ActiveRecord::Migration
  def change
    remove_column :vods, :user_id, :integer
  end
end
