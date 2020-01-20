class Letter < ApplicationRecord
  belongs_to :word
  has_one :player, through: :word
end
