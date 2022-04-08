class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  has_one_attached :profile_image

  validates :name, presence: true
  validates :kana_name, presence: true, format: { with: /\A[ァ-ヶー－]+\z/ }
  validates :user_name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :age, presence: true

  enum age: { teens:0, twenties:1, thirties:2, fourties:3, fifties:4 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

end
