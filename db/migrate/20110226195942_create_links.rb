class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :title
      t.string :url
      t.integer :note_id
      t.integer :evensong_id

      t.timestamps
    end

    add_index :links, :note_id
    add_index :links, :evensong_id
  end

  def self.down
    remove_index :links, :note_id
    remove_index :links, :evensong_id

    drop_table :links
  end
end
