class Placement < ApplicationRecord
  belongs_to :move, optional: true
  has_one :player, through: :word

  scope :between,  -> (x_min, y_min, x_max, y_max) {
    where("x BETWEEN ? AND ? AND y BETWEEN ? AND ? ",
          x_min, x_max, y_min, y_max)
  }
  scope :not_at,  -> (x_coord, y_coord) {
    merge(unscoped.where.not(x: x_coord).
          or(unscoped.where.not(y: y_coord)))
  }

  def coords
    [ x, y ]
  end
end
