class Group < ApplicationRecord

  has_many :user_groups
  has_many :users, through: :user_groups, dependent: :destroy

  belongs_to :user   # グループオーナー表示のために追記

  has_one_attached :group_image

  validates :name, presence: true
  validates :introduction, presence: true


  def get_group_image(width, height)
    unless group_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      group_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    group_image.variant(resize_to_limit: [width, height]).processed
  end
end
