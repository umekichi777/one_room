class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy

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

end
