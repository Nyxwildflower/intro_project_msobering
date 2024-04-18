class Artist < ApplicationRecord
  has_many :artworks

  # Most fields can be unknown, so the only presence check is used on the title.
  validates :title, presence: true, length: {minimum: 2}
  validates :birth_date, :death_date, numericality: {only_integer: true}, allow_nil: true
end
