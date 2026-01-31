class Post < ApplicationRecord
  belongs_to :team
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 1000 }
  validates :team_id, presence: true

  scope :active_user, -> { joins(:user).where(users: { is_active: true }) }
end
