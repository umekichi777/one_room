class Post < ApplicationRecord

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many_attached :images

  validates :title, presence: true
  validates :body, presence: true, length: {maximum: 1000}

# 引数で渡されたuserのidがfavoritesテーブルに存在するかどうか、調べる処理
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end
