class AddClientIpToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :client_ip, :string
  end
end
