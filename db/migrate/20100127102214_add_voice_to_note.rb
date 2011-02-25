# coding: UTF-8

class AddVoiceToNote < ActiveRecord::Migration
  def self.up
    add_column :notes, :voice, :string
  end

  def self.down
    remove_column :notes, :voice
  end
end
