# frozen_string_literal: true

class User < ApplicationRecord
  include UuidConcern

  has_many :user_jtis, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :user_conversations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :uuid, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\Z/ }
end
