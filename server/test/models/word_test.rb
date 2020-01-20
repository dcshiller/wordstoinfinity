require 'test_helper'

class WordTest < ActiveSupport::TestCase
  def word
    create :word, spelling: "test"
  end

  test "Basics" do
    assert word.letters.count == 4
    assert word.print == "test"
  end
end
