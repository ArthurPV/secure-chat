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
          user = Fabricate(:user)

          expect(User.create(email: user.email).errors.full_messages).to include("Email has already been taken")
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
          user = Fabricate(:user)

          expect(User.create(username: user.username).errors.full_messages).to include("Username has already been taken")
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
          user = Fabricate(:user)

          expect(User.create(phone_number: user.phone_number).errors.full_messages).to include("Phone number has already been taken")
        end

        context 'public_key' do
          it 'required' do
            expect(User.create(public_key: nil).errors.full_messages).to include("Public key can't be blank")
          end
        end

        context 'private_key' do
          it 'required' do
            expect(User.create(private_key: nil).errors.full_messages).to include("Private key can't be blank")
          end
        end
      end
    end
  end

  describe 'callbacks' do
    context 'create_user_key' do
      it 'create user_key' do
        user = Fabricate(:user)

        expect(user.user_key).to be_present
        expect(user.user_key.persisted?).to be_truthy
      end
    end
  end
end
