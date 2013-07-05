FactoryGirl.define do
  factory :athlete do
    name { Forgery::Name.full_name }
  end
end
