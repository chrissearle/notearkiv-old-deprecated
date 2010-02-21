require 'test_helper'

class LanguageTest < ActiveSupport::TestCase
  test "name required not provided" do
    language = Language.new
    assert !language.save, "Saved without a name"
  end

  test "name required and provided" do
    language = Language.new
    language.name = "Test Language"
    assert language.save, "Failed to save with name"
  end
end
