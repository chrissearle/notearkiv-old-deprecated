# coding: UTF-8

class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :display_id
      t.string :title
      t.integer :count_originals
      t.integer :count_copies
      t.integer :count_instrumental

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
