# frozen_string_literal: true

class User < ApplicationRecord
  include UuidConcern

  attr_accessor :public_key, :private_key

  encrypts :phone_number, deterministic: true
  encrypts :username, deterministic: true

  has_many :user_jtis, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :user_conversations
  has_one :user_key, autosave: true, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :public_key, presence: true, on: :create
  validates :private_key, presence: true, on: :create
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :uuid, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9_]+\Z/ }
  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A[0-9]{10}\Z/ }

  before_create :create_user_key

  private

  def create_user_key
    self.user_key = UserKey.new(public_key:, private_key:)
  end
end
