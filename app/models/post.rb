class Post < ApplicationRecord
    validates :title, presence: true
    validates :body, presence: true
    has_one_attached :image  
    belongs_to :user
end
