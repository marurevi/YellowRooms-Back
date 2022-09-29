require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { FactoryBot.create(:room) }
  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(room).to be_valid
    end

    it 'is not valid without a name' do
      room.name = nil
      expect(room).to_not be_valid
    end

    it 'is not valid without a stars' do
      room.stars = nil
      expect(room).to_not be_valid
    end

    it 'is not valid with a non integer stars' do
      room.stars = 3.5
      expect(room).to_not be_valid
    end

    it 'is not valid without a persons_allowed' do
      room.persons_allowed = nil
      expect(room).to_not be_valid
    end

    it 'is not valid without a photo' do
      room.photo = nil
      expect(room).to_not be_valid
    end

    it 'is not valid with a non url photo' do
      room.photo = 'photo'
      expect(room).to_not be_valid
    end

    it 'is not valid without a description' do
      room.description = nil
      expect(room).to_not be_valid
    end

    it 'is not valid without a price' do
      room.price = nil
      expect(room).to_not be_valid
    end

    it 'is not valid with a non numeric price' do
      room.price = 'price'
      expect(room).to_not be_valid
    end
  end
end
