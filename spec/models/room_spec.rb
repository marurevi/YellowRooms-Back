require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      room = FactoryBot.build(:room)
      expect(room).to be_valid
    end

    it 'is not valid without a name' do
      room = FactoryBot.build(:room, name: nil)
      expect(room).to_not be_valid
    end

    it 'is not valid without a stars' do
      room = FactoryBot.build(:room, stars: nil)
      expect(room).to_not be_valid
    end

    it 'is not valid without a persons_allowed' do
      room = FactoryBot.build(:room, persons_allowed: nil)
      expect(room).to_not be_valid
    end

    it 'is not valid without a photo' do
      room = FactoryBot.build(:room, photo: nil)
      expect(room).to_not be_valid
    end

    it 'is not valid without a description' do
      room = FactoryBot.build(:room, description: nil)
      expect(room).to_not be_valid
    end

    it 'is not valid without a price' do
      room = FactoryBot.build(:room, price: nil)
      expect(room).to_not be_valid
    end
  end
end
