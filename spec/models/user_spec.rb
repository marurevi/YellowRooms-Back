require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    context 'a valid user' do
      let(:user) { create(:user) }

      it 'should have an username' do
        user.username = nil
        expect(user).not_to be_valid
      end

      it 'should not have a duplicate username' do
        u2 = build(:user, username: user.username)
        expect(u2).not_to be_valid
      end

      it 'should not have non-letter characters in its username' do
        user.username = 'user12@3'
        expect(user).not_to be_valid
      end
    end
  end
end
