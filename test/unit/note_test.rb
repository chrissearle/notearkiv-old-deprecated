require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  test "title item and count_originals required not provided" do
    note = Note.new

    assert !note.save, "Saved without a title item and count_originals"
  end

  test "title and item required not provided" do
    note = Note.new

    note.count_originals = 0

    assert !note.save, "Saved without a title and item"
  end

  test "title and count_originals required not provided" do
    note = Note.new

    note.item = 1

    assert !note.save, "Saved without a title and count_originals"
  end

  test "item and count_originals required not provided" do
    note = Note.new

    note.title = "Test note"

    assert !note.save, "Saved without a item and count_originals"
  end

  test "title required not provided" do
    note = Note.new

    note.count_originals = 0
    note.item = 1

    assert !note.save, "Saved without a title"
  end

  test "item required not provided" do
    note = Note.new

    note.title = "Test note"
    note.count_originals = 0

    assert !note.save, "Saved without a item"
  end

  test "count_originals required not provided" do
    note = Note.new

    note.title = "Test note"
    note.item = 1

    assert !note.save, "Saved without a count_originals"
  end

  test "title item and count_originals required and provided" do
    note = Note.new

    note.title = "Test note"
    note.count_originals = 0
    note.item = 1

    assert note.save, "Failed to save with a title item and count_originals"
  end
end
