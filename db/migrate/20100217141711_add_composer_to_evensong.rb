# coding: UTF-8

class AddComposerToEvensong < ActiveRecord::Migration
  def self.up
    add_column :evensongs, :composer_id, :integer
  end

  def self.down
    remove_column :evensongs, :composer_id
  end
end
