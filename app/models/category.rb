class Category < ApplicationRecord
  has_and_belongs_to_many :artworks

  # There are only so many things that could possibly be validated here.
  validates :title, presence: true
  validates :title, length: {minimum: 2}
end
