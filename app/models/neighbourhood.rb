class Neighbourhood < ApplicationRecord
  has_many :calls

  validates :name, :location, presence: true
  validates :name, length: { maximum: 75 }
end
