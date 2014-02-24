class AddBodyToStream < ActiveRecord::Migration
  def change
    add_column :streams, :body, :text
  end
end
