require 'test_helper'

class EvensongTest < ActiveSupport::TestCase
  test "title composer and genre required not provided" do
    evensong = Evensong.new

    assert !evensong.save, "Saved without a title composer and genre"
  end

  test "title and composer required not provided" do
    evensong = Evensong.new

    evensong.genre = Genre.new( :name => "Test Genre" )

    assert !evensong.save, "Saved without a title and composer"
  end

  test "title and genre required not provided" do
    evensong = Evensong.new

    evensong.composer = Composer.new( :name => "Test Composer" )

    assert !evensong.save, "Saved without a title and genre"
  end

  test "composer and genre required not provided" do
    evensong = Evensong.new

    evensong.title = "Test evensong"

    assert !evensong.save, "Saved without a composer and genre"
  end

  test "title required not provided" do
    evensong = Evensong.new

    evensong.genre = Genre.new( :name => "Test Genre" )
    evensong.composer = Composer.new( :name => "Test Composer" )

    assert !evensong.save, "Saved without a title"
  end

  test "composer required not provided" do
    evensong = Evensong.new

    evensong.title = "Test evensong"
    evensong.genre = Genre.new( :name => "Test Genre" )

    assert !evensong.save, "Saved without a composer"
  end

  test "genre required not provided" do
    evensong = Evensong.new

    evensong.title = "Test evensong"
    evensong.composer = Composer.new( :name => "Test Composer" )

    assert !evensong.save, "Saved without a genre"
  end

  test "title composer and genre required and provided" do
    evensong = Evensong.new

    evensong.title = "Test evensong"
    evensong.genre = Genre.new( :name => "Test Genre" )
    evensong.composer = Composer.new( :name => "Test Composer" )

    assert evensong.save, "Failed to save with a title composer and genre"
  end
end
