class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  belongs_to :team
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users

  validates :name, presence: true, length: { maximum: 50 }
  validates :introduction, presence: true, length: { maximum: 500 }
  validates :owner_id, presence: true
  validates :team_id, presence: true

  scope :active_owner, -> { joins(:owner).where(users: { is_active: true }) }
end