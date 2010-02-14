class RemoveEvensongGenres < ActiveRecord::Migration
  def self.up
    drop_table :evensong_genres
  end

  def self.down
    create_table :evensong_genres do |t|
      t.string :name

      t.timestamps
    end
  end
end
