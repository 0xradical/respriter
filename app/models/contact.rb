class Contact < ApplicationRecord
  validates :name, :email, :message, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, length: { minimum: 5 }
end
