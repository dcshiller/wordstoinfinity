FactoryBot.define do
  sequence :coords do |n|
    n
  end

  factory :letter do
    x { generate :coords }
    y { 1 }
    word { create :word, spelling: '' }
    value { ('a'..'z').to_a.sample }
  end
end

