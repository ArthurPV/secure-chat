# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'columns' do
    context 'validations' do
      context 'email' do
        it 'required' do
          expect(User.create(email: nil).valid?).to eq(false)
        end

        it 'valid' do
          expect(User.create(email: 'test').valid?).to eq(false)
        end

        it 'unique' do
          User.create!(email: 'user@localdev.me', password: 'password', username: 'xyz')

          expect(User.new(email: 'user@localdev.me', password: 'password', username: 'xyz2').valid?).to eq(false)
        end
      end

      context 'encryped_password' do
        it 'required' do
          expect(User.new(email: 'user@localdev.me').valid?).to eq(false)
        end
      end

      context 'username' do
        it 'required' do
          expect(User.new(email: 'user@localdev.me', password: 'password').valid?).to eq(false)
        end

        it 'unique' do
          User.create!(email: 'user@localdev.me', password: 'password', username: 'xyz')

          expect(User.new(email: 'user2@localdev.me', password: 'password', username: 'xyz').valid?).to eq(false)
        end
      end
    end
  end
end
