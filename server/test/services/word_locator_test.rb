require 'test_helper'

class WordLocatorTest < ActiveSupport::TestCase
  def setup_letters
    grid = [
      %w( c a t _ _ _ s ),
      %w( a _ a r r o w ),
      %w( r a t _ o _ o ),
      %w( t _ t _ o a r ),
      %w( _ _ o a t _ d ),
      %w( _ _ o _ _ _ _ ),
    ]
    grid.each.with_index do |row, y_idx|
      row.each.with_index do |l, x_idx|
        create :placement, x: x_idx, y: y_idx, value: l, move: Move.new unless l == "_"
      end
    end
  end

  test "Try" do
    setup_letters
    located_words = WordLocator.new(0, 0).locate
    assert located_words.include?('arrow')
    assert located_words.include?('tattoo')
    refute located_words.include?('cad')
    refute located_words.include?('word')
    located_words = WordLocator.new(3, 3, 3).locate
    refute located_words.include?('arrow')
    refute located_words.include?('tattoo')
    assert located_words.include?('oat')
    assert located_words.include?('root')
  end
end
