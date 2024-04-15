class Artwork < ApplicationRecord
  belongs_to :artist, optional: true
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :exhibitions
end
