class RenameStreamsViewsersToViewers < ActiveRecord::Migration
  def change
    rename_column :streams, :viewsers, :viewers
  end
end
