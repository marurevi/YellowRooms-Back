class Room < ApplicationRecord
  has_many :reservations
  has_many :users, through: :reservations

  validates :name, presence: true
  validates :stars, presence: true, numericality: { only_integer: true }
  validates :persons_allowed, presence: true, numericality: { only_integer: true }
  validates :photo, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validates :description, presence: true
  validates :price, presence: true, numericality: true
end
