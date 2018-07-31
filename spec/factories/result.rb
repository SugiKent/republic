FactoryBot.define do
  factory :result do
    comment '最高の授業です'
    grade 'A'
    score 3
    rep_1 1
    rep_2 2
    rep_3 3

    to_create do |instance|
      instance.save validate: false
    end
  end

  factory :blank_result, class: Result do

  end
end
