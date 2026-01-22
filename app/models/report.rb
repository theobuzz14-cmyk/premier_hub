class Report < ApplicationRecord
  belongs_to :user
  # thread_id と comment_id はどちらかが入る形になるため optional: true で関連付け
  belongs_to :post, foreign_key: 'thread_id', optional: true
  belongs_to :comment, optional: true

  validates :reason, presence: true, length: { maximum: 500 }
  validates :status, presence: true

  # 処理状態の管理用
  enum status: { pending: 0, processed: 1 }
end