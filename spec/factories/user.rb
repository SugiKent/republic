FactoryBot.define do
  factory :user do
    email '13xx999z@rikkyo.ac.jp'
    password 'password'
    password_confirmation 'password'
    confirmed_at Date.today
  end
end
