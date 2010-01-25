class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.int :display_id
      t.string :title
      t.int :count_originals
      t.int :count_copies
      t.int :count_instrumental

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
