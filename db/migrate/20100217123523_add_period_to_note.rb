# coding: UTF-8

class AddPeriodToNote < ActiveRecord::Migration
  def self.up
    add_column :notes, :period_id, :integer
  end

  def self.down
    remove_column :notes, :period_id
  end
end
