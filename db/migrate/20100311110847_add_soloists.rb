# coding: UTF-8

class AddSoloists < ActiveRecord::Migration
  def self.up
    add_column :notes, :soloists, :string
    add_column :evensongs, :soloists, :string
  end

  def self.down
    remove_column :notes, :soloists
    remove_column :evensongs, :soloists
  end
end
