class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :owned_groups, class_name: 'Group', foreign_key: 'owner_id', dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 20 }

  # Deviseの認証時に呼ばれるメソッド
  def active_for_authentication?
    # is_activeがtrue、かつ管理者から凍結されていない場合にログインを許可
    super && self.is_active
  end

  # ログイン拒否時のエラーメッセージを指定
  def inactive_message
    self.is_active ? super : :withdraw # :withdraw は後で辞書ファイルに追加
  end
end
