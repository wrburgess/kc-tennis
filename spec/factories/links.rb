FactoryBot.define do
  factory :link do
    url_type { UrlTypes.all.sample }
    url { Faker::Internet.url }
  end
end
