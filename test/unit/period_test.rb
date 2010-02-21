require 'test_helper'

class PeriodTest < ActiveSupport::TestCase
  test "name required not provided" do
    period = Period.new
    assert !period.save, "Saved without a name"
  end

  test "name required and provided" do
    period = Period.new
    period.name = "Test Period"
    assert period.save, "Failed to save with name"
  end
end
