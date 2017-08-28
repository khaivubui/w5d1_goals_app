# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :user do
    username { Faker::Name.first_name }
    password { Faker::RickAndMorty.quote }

    factory :user_with_no_username do
      username ''
    end

    factory :user_with_no_password do
      password ''
    end

    factory :user_with_short_password do
      password { Faker::RickAndMorty.quote[0..4] }
    end
  end
end
