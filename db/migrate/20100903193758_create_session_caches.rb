class CreateSessionCaches < ActiveRecord::Migration
  def self.up
    create_table :session_caches do |t|
      t.string :serialized_session

      t.timestamps
    end
  end

  def self.down
    drop_table :session_caches
  end
end
