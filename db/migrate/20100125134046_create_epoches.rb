class CreateEpoches < ActiveRecord::Migration
  def self.up
    create_table :epoches do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :epoches
  end
end
