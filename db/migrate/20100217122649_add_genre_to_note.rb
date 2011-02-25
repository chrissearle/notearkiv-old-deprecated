# coding: UTF-8

class AddGenreToNote < ActiveRecord::Migration
  def self.up
    add_column :notes, :genre_id, :integer
  end

  def self.down
    remove_column :notes, :genre_id
  end
end
