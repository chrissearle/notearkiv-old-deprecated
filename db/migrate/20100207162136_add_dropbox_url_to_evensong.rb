class AddDropboxUrlToEvensong < ActiveRecord::Migration
  def self.up
    add_column :evensongs, :url, :string
  end

  def self.down
    remove_column :evensongs, :url
  end
end
