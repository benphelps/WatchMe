class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :name
      t.string :description
      t.string :public_key
      t.string :private_key
      t.string :user_id

      t.timestamps
    end
  end
end
