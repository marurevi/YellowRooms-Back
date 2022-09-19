require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:reservation) { FactoryBot.create(:reservation) }
  describe 'Validations' do
    it 'is invalid without a user' do
      reservation.user = nil
      expect(reservation).to_not be_valid
    end
    it 'is invalid without a room' do
      reservation.room = nil
      expect(reservation).to_not be_valid
    end
    it 'is invalid without a start date' do
      reservation.start_date = nil
      expect(reservation).to_not be_valid
    end
    it 'is invalid without an end date' do
      reservation.end_date = nil
      expect(reservation).to_not be_valid
    end
    it 'is invalid without a city' do
      reservation.city = nil
      expect(reservation).to_not be_valid
    end
    it 'is invalid if start date is after end date' do
      reservation.start_date = Date.tomorrow
      reservation.end_date = Date.today
      expect(reservation).to_not be_valid
    end

    it 'is invalid if start date is equal to end date' do
      reservation.start_date = Date.today
      reservation.end_date = Date.today
      expect(reservation).to_not be_valid
    end

    it 'is invalid if start date is before today' do
      reservation.start_date = Date.yesterday
      reservation.end_date = Date.today
      expect(reservation).to_not be_valid
    end
    it 'is invalid if end date is before today' do
      reservation.start_date = Date.today
      reservation.end_date = Date.yesterday
      expect(reservation).to_not be_valid
    end
    it 'is invalid if there is another reservation for the same room and dates' do
      reservation2 = FactoryBot.build(:reservation, room: reservation.room, start_date: reservation.start_date,
                                                    end_date: reservation.end_date)
      expect(reservation2).to_not be_valid
    end
  end
end
