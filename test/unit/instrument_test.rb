require 'test_helper'

class InstrumentTest < ActiveSupport::TestCase
  test "name required not provided" do
    composer = Composer.new
    assert !composer.save, "Saved without a name"
  end

  test "name required and provided" do
    composer = Composer.new
    composer.name = "Test Composer"
    assert composer.save, "Failed to save with name"
  end
end
