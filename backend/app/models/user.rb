# frozen_string_literal: true

class User < ApplicationRecord
  include UuidConcern

  attr_accessor :public_key, :private_key

  encrypts :phone_number, deterministic: true
  encrypts :username, deterministic: true

  has_and_belongs_to_many :user_conversations
  has_and_belongs_to_many :conversations, join_table: "user_conversations"

  has_many :user_jtis, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :user_contact_requests, dependent: :destroy
  has_many :user_contact_requesteds, class_name: "UserContactRequest", foreign_key: "contacted_id", dependent: :destroy
  has_many :user_contacteds, dependent: :destroy

  has_one :user_key, autosave: true, dependent: :destroy

  has_one_attached :profile_picture

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
  validates :profile_picture, content_type: %w[image/png image/jpeg], size: { less_than: 5.megabytes }

  before_create :create_user_key

  def profile_picture_url
    profile_picture.attached? ? profile_picture.url : nil
  end

  def user_contacts
    UserContact.where(uuid: user_contacteds.pluck(:user_contact_id))
  end

  private

  def create_user_key
    self.user_key = UserKey.new(public_key:, private_key:)
  end
end
