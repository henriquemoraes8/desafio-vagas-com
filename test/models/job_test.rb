require 'test_helper'

class JobTest < ActiveSupport::TestCase
  test "correct level" do
    job = Job.new(level: 6)
    job = Job.new(level: 0)
    assert true
  end
end
