class Unit < ApplicationRecord
  has_and_belongs_to_many :calls

  validates :code, :name, presence: true
  validates :code, length: { maximum: 10 }
  validates :name, length: { maximum: 75 }
end
