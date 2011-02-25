# coding: UTF-8

class AddImportRole < ActiveRecord::Migration
  def self.up
    Role.new( :name => 'import').save!
  end

  def self.down
    Role.find_by_name('import').delete
  end
end
