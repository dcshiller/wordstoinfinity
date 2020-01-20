class Placement < ApplicationRecord
  belongs_to :move, optional: true
  has_one :player, through: :word
end
