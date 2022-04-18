class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :user_groups
  has_many :groups, through: :user_groups, dependent: :destroy
  has_many :owned_groups, class_name: "Group"   # グループオーナー表示のために追記
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy


  has_many :followings, through: :relationships, source: :followed   # followed_id: フォローされたユーザー
  has_many :followers, through: :reverse_of_relationships, source: :follower   # follower_id: フォローしたユーザー


  has_one_attached :profile_image

  validates :name, presence: true
  validates :kana_name, presence: true, format: { with: /\A[ァ-ヶー－]+\z/ }
  validates :user_name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :age, presence: true

  # 年代のenumの定義
  enum age: { teens:0, twenties:1, thirties:2, fourties:3, fifties:4 }

  # プロフィール画像　登録されていない場合no_image画像を表示させる
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  # ログイン時、退会済のユーザーが同じアカウントでログインできないよう制約を設ける
  # is_deletedがfalseならtrueを返す
  def active_for_authentication?
    super && (is_deleted == false)
  end

end
