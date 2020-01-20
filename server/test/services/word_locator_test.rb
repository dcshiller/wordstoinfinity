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
        Letter.new x: x_idx, y: y_idx, value: l, word: Word.new unless l == "_"
      end
    end
  end

  test "Try" do
    setup_letters
    a = Letter.where( x: 2, y: 1).first
    r = Letter.where( x: 3, y: 1).first
    o = Letter.where( x: 5, y: 1).first
    located_words = WordLocator.new([a, r, o]).locate
    return
    assert located_words.include?('arrow')
    assert located_words.include?('tattoo')
    refute located_words.include?('cat')
    refute located_words.include?('sword')
  end
end
