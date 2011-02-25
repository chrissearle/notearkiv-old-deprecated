# coding: UTF-8

class CreateEvensongGenres < ActiveRecord::Migration
  def self.up
    create_table :evensong_genres do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :evensong_genres
  end
end
