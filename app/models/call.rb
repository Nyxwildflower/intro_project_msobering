class Call < ApplicationRecord
  belongs_to :neighbourhood
  has_and_belongs_to_many :units

  validates :call_time, :incident_type, :ward, presence: true
  validates :incident_type, :ward, length: { in: 3..75 }
end
