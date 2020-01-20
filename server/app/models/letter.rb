class Letter < ApplicationRecord
  belongs_to :word, optional: true
  has_one :player, through: :word
end
