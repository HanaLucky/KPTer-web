FactoryGirl.define do
  factory :social_profile do
    user nil
    provider "MyString"
    uid "MyString"
    name "MyString"
    nickname "MyString"
    email "MyString"
    url "MyString"
    image_url "MyString"
    description "MyString"
    other "MyText"
    credentials "MyText"
    raw_info "MyText"
  end
end
