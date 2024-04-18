class Exhibition < ApplicationRecord
  has_and_belongs_to_many :artworks

  validates :title, presence: true, length: {minimum: 2}
  validates :description, :gallery_title, length: {minimum: 4}, allow_nil: true
end
