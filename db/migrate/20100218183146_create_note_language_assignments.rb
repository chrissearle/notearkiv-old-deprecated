# coding: UTF-8

class CreateNoteLanguageAssignments < ActiveRecord::Migration
  def self.up
    create_table :note_language_assignments do |t|
      t.integer :note_id
      t.integer :language_id

      t.timestamps
    end
  end

  def self.down
    drop_table :note_language_assignments
  end
end
