class AddGenreToEvensong < ActiveRecord::Migration
  def self.up
    add_column :evensongs, :genre_id, :integer
  end

  def self.down
    remove_column :evensongs, :genre_id
  end
end
