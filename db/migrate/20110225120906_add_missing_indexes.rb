class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    add_index :evensongs, :composer_id
    add_index :evensongs, :genre_id
    add_index :note_language_assignments, :note_id
    add_index :note_language_assignments, :language_id
    add_index :notes, :composer_id
    add_index :notes, :genre_id
    add_index :notes, :period_id
    add_index :user_role_assignments, :user_id
    add_index :user_role_assignments, :role_id
  end

  def self.down
    remove_index :evensongs, :composer_id
    remove_index :evensongs, :genre_id
    remove_index :note_language_assignments, :note_id
    remove_index :note_language_assignments, :language_id
    remove_index :notes, :composer_id
    remove_index :notes, :genre_id
    remove_index :notes, :period_id
    remove_index :user_role_assignments, :user_id
    remove_index :user_role_assignments, :role_id
  end
end
