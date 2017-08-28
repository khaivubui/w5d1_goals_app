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

class Goal < ApplicationRecord
  validates :user_id, :body, :goal_type, :completed, presence: true
  validates :goal_type, inclusion: {
    in: %w(PRIVATE PUBLIC),
    message: 'Invalid type'
  }
  after_initialize :ensure_completion_status, :ensure_goal_type

  belongs_to :user

  def ensure_completion_status
    self.completed ||= false
  end

  def ensure_goal_type
    self.goal_type ||= 'PRIVATE'
  end
end
