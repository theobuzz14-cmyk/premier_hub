class Team < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :logo_url, presence: true
end
