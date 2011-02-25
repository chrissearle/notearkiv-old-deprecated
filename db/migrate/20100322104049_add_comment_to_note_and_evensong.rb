# coding: UTF-8

class AddCommentToNoteAndEvensong < ActiveRecord::Migration
  def self.up
    add_column :notes, :comment, :text
    add_column :evensongs, :comment, :text
  end

  def self.down
    remove_column :notes, :comment
    remove_column :evensongs, :comment
  end
end
