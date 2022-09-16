class Room < ApplicationRecord
  has_many :reservations
  has_many :users, through: :reservations

  validates :name, presence: true
  validates :stars, presence: true
  validates :persons_allowed, presence: true
  validates :photo, presence: true
  validates :description, presence: true
  validates :price, presence: true
end
