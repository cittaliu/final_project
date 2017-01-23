class Contact < ApplicationRecord
  belongs_to :company

  has_many :usercontacts, dependent: :destroy
  has_many :users, through: :usercontacts
end
