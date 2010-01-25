class CreateEpochs < ActiveRecord::Migration
  def self.up
    create_table :epochs do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :epochs
  end
end
