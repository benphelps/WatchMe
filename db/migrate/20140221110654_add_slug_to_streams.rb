class AddSlugToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :slug, :string, unique: true
  end
end
