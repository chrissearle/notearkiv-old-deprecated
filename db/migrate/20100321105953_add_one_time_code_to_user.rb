class AddOneTimeCodeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :onetime, :string
  end

  def self.down
    remove_column :users, :onetime
  end
end
