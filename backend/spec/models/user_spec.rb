# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'columns' do
    context 'validations' do
      context 'email' do
        it 'required' do
          expect(User.create(email: nil).errors.full_messages).to include("Email can't be blank")
        end

        it 'validate' do
          expect(User.create(email: 'test').errors.full_messages).to include("Email is invalid")
        end

        it 'unique' do
          User.create!(email: 'user@localdev.me', password: 'password', username: 'xyz', phone_number: '1234567890')

          expect(User.create(email: 'user@localdev.me').errors.full_messages).to include("Email has already been taken")
        end
      end

      context 'encryped_password' do
        it 'required' do
          expect(User.create(password: nil).errors.full_messages).to include("Password can't be blank")
        end
      end

      context 'username' do
        it 'required' do
          expect(User.create(username: nil).errors.full_messages).to include("Username can't be blank")
        end

        it 'unique' do
          User.create!(email: 'user@localdev.me', password: 'password', username: 'xyz', phone_number: '1234567890')

          expect(User.create(username: 'xyz').errors.full_messages).to include("Username has already been taken")
        end
      end

      context 'phone_number' do
        it 'required' do
          expect(User.create(phone_number: nil).errors.full_messages).to include("Phone number can't be blank")
        end

        it 'validate' do
          expect(User.create(phone_number: '123').errors.full_messages).to include("Phone number is invalid")
        end

        it 'unique' do
          user = User.create!(email: 'user@localdev.me', password: 'password', username: 'xyz', phone_number: '1234567890')

          expect(User.create(phone_number: '1234567890').errors.full_messages).to include("Phone number has already been taken")
        end
      end
    end
  end
end
