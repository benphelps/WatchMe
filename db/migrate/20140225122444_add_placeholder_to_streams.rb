class AddPlaceholderToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :placeholder, :string
  end
end
