class Company < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :openings, dependent: :destroy
end
