# frozen_string_literal: true

Fabricator(:user) do
  password '123456'
  email Faker::Internet.email
  username Faker::Internet.user_name
  phone_number Faker::PhoneNumber.cell_phone
end
