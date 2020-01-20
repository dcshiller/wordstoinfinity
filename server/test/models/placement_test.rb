require 'test_helper'

class LetterTest < ActiveSupport::TestCase
  def placement
    @placement ||= create :placement
  end

  test "the truth" do
    assert placement.x
    assert true
  end
end
