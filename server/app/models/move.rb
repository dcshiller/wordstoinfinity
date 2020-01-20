class Move < ApplicationRecord
  has_many :placements
  belongs_to :player
end
