# coding: UTF-8

class AddMusicUrl < ActiveRecord::Migration
  def self.up
    add_column :notes, :music_url, :string
    add_column :evensongs, :music_url, :string
  end

  def self.down
    remove_column :notes, :music_url
    remove_column :evensongs, :music_url
  end
end
