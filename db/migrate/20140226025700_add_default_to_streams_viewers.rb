class AddDefaultToStreamsViewers < ActiveRecord::Migration
  def change
    change_column :streams, :viewers, :integer, default: 0
  end
end
