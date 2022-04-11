class Post < ApplicationRecord

  belongs_to :user, dependent: :destroy

  has_many_attached :images

  validates :title, presence: true
  validates :body, presence: true, length: {maximum: 1000}
end
