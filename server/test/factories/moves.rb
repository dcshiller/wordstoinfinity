FactoryBot.define do
  factory :move do
    player { create :player }
    transient do
      spelling { "car" }
    end

    after(:create) do |move, evaluator|
      evaluator.spelling.split("").each do |l|
        create :placement, value: l, move: move
      end
    end
  end
end

