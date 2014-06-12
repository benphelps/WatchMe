class AddStreamIdToVods < ActiveRecord::Migration
  def change
    add_column :vods, :stream_id, :integer
  end
end
