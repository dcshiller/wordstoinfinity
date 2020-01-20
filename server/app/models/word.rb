class Word < ApplicationRecord
  has_many :letters
  belongs_to :player


  def print
    letters.map { |l| l.value }.join("")
  end
end
