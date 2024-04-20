class Artwork < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :tile_size, resize_to_fill: [300,300], quality: 100
  end

  belongs_to :artist, optional: true
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :exhibitions

  # Most of the data is in strings due to added characters, so there are no
  # numericality checks here. The length check for artwork titles is so low
  # because artwork #142 was titled "1". I hate it.
  validates :title, presence: true, length: {minimum: 1}
  validates :year, :medium, :place_of_origin, :dimensions, :description, length: {minimum: 3}, allow_nil: true
end
