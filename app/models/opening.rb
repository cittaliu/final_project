class Opening < ApplicationRecord
  belongs_to :company

  has_many :opportunities, dependent: :destroy
  has_many :users, through: :opportunities
end
