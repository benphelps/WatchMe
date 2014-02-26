class AddLiveToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :live, :boolean
  end
end
