# coding: UTF-8

class AddComposerToNote < ActiveRecord::Migration
  def self.up
    add_column :notes, :composer_id, :integer
  end

  def self.down
    remove_column :notes, :composer_id
  end
end
