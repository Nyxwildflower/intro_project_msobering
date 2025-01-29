class Call < ApplicationRecord
  belongs_to :neighbourhood
  has_and_belongs_to_many :units
end
