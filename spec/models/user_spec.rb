# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build :user }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:session_token) }
  it 'should automatically generate session_token' do
    user1 = create(:user)
    expect(user1.valid?).to be true
  end
  it 'should require password' do
    user1 = User.new(username: Faker::Name.first_name)
    user1.save
    expect(user1.errors.full_messages).to be_truthy
  end

  it 'should require password of length 6' do
    user1 = User.new(username: Faker::Name.first_name,
                        password: Faker::RickAndMorty.quote[0..4])
    user1.save
    expect(user1.errors.full_messages).to be_truthy
  end

  describe '#find_by_credentials' do
    let!(:user1) { User.create(username: 'Apple', password: 'Apples') }

    it 'should find user given username & password' do
      # user1 = User.create(username: 'Apple', password: 'Apples')
      found_user = User.find_by_credentials(username: 'Apple',
                                            password: 'Apples')
      expect(User.all).to include(user1)
      expect(found_user).to be_truthy
      expect(found_user).to eq(user1)
    end

    it 'should not find user given incorrect username' do
      # user1 = User.create(username: 'Apple', password: 'Apples')
      found_user = User.find_by_credentials(username: 'Banana',
                                            password: 'Apples')
      expect(found_user).to be_falsy
      expect(found_user).not_to eq(user1)
    end

    it 'should not find user given incorrect password' do
      # user1 = User.create(username: 'Apple', password: 'Apples')
      found_user = User.find_by_credentials(username: 'Apple',
                                            password: 'Bananas')
      expect(found_user).to be_falsy
      expect(found_user).not_to eq(user1)
    end
  end
end
