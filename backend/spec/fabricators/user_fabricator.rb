# frozen_string_literal: true

Fabricator(:user) do
  password '123456'
  email Faker::Internet.email
end
