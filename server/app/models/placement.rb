class Placement < ApplicationRecord
  belongs_to :move, optional: true
  has_one :player, through: :word

  def coords
    [ x, y ]
  end
end
