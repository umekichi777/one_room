class Tag < ApplicationRecord

  has_many :posts, through: :post_tags
  has_many :post_tags, foreign_key: 'tag_id', dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
