class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group

  # enumの設定（定義書：0:申請中, 1:承認済）
  enum status: { pending: 0, approved: 1 }
end