class Company < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :openings, dependent: :destroy

  validates :website, uniqueness: true
  scope :name_like, -> (name) { where("name ilike ?", name)}
  def self.search(term)
  where('LOWER(name) LIKE :term OR LOWER(website) LIKE :term', term: "%#{term.downcase}%")
  end
end
