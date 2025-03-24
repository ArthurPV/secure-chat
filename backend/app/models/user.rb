# frozen_string_literal: true

class User < ApplicationRecord
  include UuidConcerns

  has_many :user_jtis, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :user_conversations
  # has_one :user_key, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :uuid, presence: true, uniqueness: true
end
