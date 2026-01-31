class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: { maximum: 300 }

  scope :active_user, -> { joins(:user).where(users: { is_active: true }) }
end
