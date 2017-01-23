class User < ApplicationRecord

  has_secure_password

  has_many :opportunities, dependent: :destroy
  has_many :openings, through: :opportunities

  has_many :usercontacts, dependent: :destroy
  has_many :contacts, through: :usercontacts

  has_many :tasks, dependent: :destroy
  has_many :contacts, through: :tasks
end
