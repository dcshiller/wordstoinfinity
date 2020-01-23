require 'test_helper'

class WordAdderTest < ActiveSupport::TestCase
  def setup
    create(:placement, x: 1, y: 0, value: 's')
    @player = create :player
  end
  test "With valid word" do
    letters = [
      create(:placement, x: 1, y: 1, value: 'c'),
      create(:placement, x: 1, y: 2, value: 'a'),
      create(:placement, x: 1, y: 3, value: 'r'),
      create(:placement, x: 1, y: 4, value: 'e')
    ]
    move = WordAdder.new(@player).add(letters)
    assert move
  end

  test "With invalid word" do

  end

  test "With valid word producing invalid word" do
  end

  test "With race condition" do

  end
end
