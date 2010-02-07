class CreateEvensongs < ActiveRecord::Migration
  def self.up
    create_table :evensongs do |t|
      t.string :title
      t.integer :psalm
      t.string :old_file_path

      t.timestamps
    end
  end

  def self.down
    drop_table :evensongs
  end
end
