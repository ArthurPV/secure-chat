# frozen_string_literal: true

Fabricator(:user) do
  password '123456'
  email Faker::Internet.email
  username Faker::Internet.username(separators: ['_'])
  phone_number Faker::Number.number(digits: 10).to_s
  public_key Faker::Crypto.sha256
  private_key Faker::Crypto.sha256
end
