class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user, presence: true
  validates :room, presence: true
  validates :start_date, :end_date, presence: true, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }
  validates_comparison_of :start_date, greater_than_or_equal_to: Date.today
  validates_comparison_of :end_date, greater_than: :start_date
  validates :city, presence: true

  validate :available?

  def available?
    return if room.blank?

    errors.add(:room, 'is not available') if room.reservations.where('start_date <= ? AND end_date >= ?', end_date,
                                                                     start_date).any?
  end
end
