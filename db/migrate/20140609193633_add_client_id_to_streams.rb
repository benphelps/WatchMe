class AddClientIdToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :client_id, :integer
  end
end
