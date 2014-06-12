class CreateVods < ActiveRecord::Migration
  def change
    create_table :vods do |t|
      t.integer :user_id
      t.string :title
      t.string :description
      t.string :basename
      t.integer :views

      t.timestamps
    end
  end
end
