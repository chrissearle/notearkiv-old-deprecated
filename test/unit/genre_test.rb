require 'test_helper'

class GenreTest < ActiveSupport::TestCase
  test "name required not provided" do
    genre = Genre.new
    assert !genre.save, "Saved without a name"
  end

  test "name required and provided" do
    genre = Genre.new
    genre.name = "Test Genre"
    assert genre.save, "Failed to save with name"
  end
end
