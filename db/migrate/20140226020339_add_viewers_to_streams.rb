class AddViewersToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :viewsers, :integer
  end
end
