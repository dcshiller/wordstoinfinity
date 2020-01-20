require 'test_helper'

class LetterTest < ActiveSupport::TestCase
  def letter
    @letter ||= create :letter
  end

  test "the truth" do
    assert letter.x
    assert true
  end
end
