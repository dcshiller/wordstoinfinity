require 'test_helper'

class WordTest < ActiveSupport::TestCase
  def move
    create :move, spelling: "test"
  end

  test "Basics" do
    assert move.placements.count == 4
    assert move.placements.map(&:value).join('') == "test"
  end
end
