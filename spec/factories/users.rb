FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { 'foobar12' }
    password_confirmation { 'foobar12' }
    notes { Faker::Lorem.sentence(word_count: 12) }
    confirmed_at { Time.zone.now - 1.day }
  end
end
