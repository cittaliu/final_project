class Contact < ApplicationRecord
  belongs_to :company

  validates :first_name, uniqueness: true
  has_many :usercontacts, dependent: :destroy
  has_many :users, through: :usercontacts

end
