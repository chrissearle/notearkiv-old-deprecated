# coding: UTF-8

class RenameUrlToDocUrl < ActiveRecord::Migration
  def self.up
    rename_column :notes, :url, :doc_url
    rename_column :evensongs, :url, :doc_url
  end

  def self.down
    rename_column :notes, :doc_url, :url
    rename_column :evensongs, :doc_url, :url
  end
end
