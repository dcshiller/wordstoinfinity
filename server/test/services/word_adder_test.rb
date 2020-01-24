require 'test_helper'

class WordAdderTest < ActiveSupport::TestCase
  def setup
    create(:placement, x: 1, y: 0, value: 's')
    @player = create :player
  end

  test "with valid word" do
    letters = [
      create(:placement, x: 1, y: 1, value: 'c'),
      create(:placement, x: 1, y: 2, value: 'a'),
      create(:placement, x: 1, y: 3, value: 'r'),
      create(:placement, x: 1, y: 4, value: 'e')
    ]
    assert_empty WordAdder.new(@player).add(letters).errors
  end

  test "With invalid word" do
    letters = [
      create(:placement, x: 1, y: 1, value: 'c'),
      create(:placement, x: 1, y: 2, value: 'a'),
      create(:placement, x: 1, y: 3, value: 'r'),
      create(:placement, x: 1, y: 4, value: 'k')
    ]
    assert_includes WordAdder.new(@player).add(letters).errors, "scark is not valid"
  end

  # test "With valid word producing invalid word"

  # test "With race condition"
end
