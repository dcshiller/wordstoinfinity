FactoryBot.define do
  factory :word do
    player { create :player }
    transient do
      spelling { "car" }
    end

    after(:create) do |word, evaluator|
      evaluator.spelling.split("").each do |l|
        create :letter, value: l, word: word
      end
    end
  end
end

