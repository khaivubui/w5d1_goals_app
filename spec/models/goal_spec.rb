# == Schema Information
#
# Table name: goals
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  body       :string           not null
#  goal_type  :string           default("PRIVATE")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  completed  :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Goal, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:user).with_message "must exist" }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:goal_type) }
  it do
    should validate_inclusion_of(:goal_type).
      in_array(['PRIVATE', 'PUBLIC'])
  end
  it { should belong_to :user }
end
