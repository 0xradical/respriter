class User < ApplicationRecord
  belongs_to :dataset

  def self.authenticated?(username, password)
    self.where(
      'username = ? AND password = crypt(?, password)',
      username,
      password
    ).exists?
  end
end
