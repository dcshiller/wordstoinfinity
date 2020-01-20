FactoryBot.define do
  sequence :coords do |n|
    n
  end

  factory :placement do
    x { generate :coords }
    y { 1 }
    move { create :move, spelling: '' }
    value { ('a'..'z').to_a.sample }
  end
end

