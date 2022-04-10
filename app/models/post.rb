class Post < ApplicationRecord
  
  belongs_to :user, dependent: :destroy
  
  has_many_attached :images
  
  validates :title, precense: true
  validates :body, precense: true, length: {maximum: 1000}
end
