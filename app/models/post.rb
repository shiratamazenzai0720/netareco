class Post < ApplicationRecord
    validates :title, presence: true
    validates :body, presence: true
    has_one_attached :image  
    belongs_to :user

    def self.search_for(content, method)
        if method == 'perfect'
          Post.where(title: content)
        elsif method == 'forward'
          Post.where('title LIKE ?', content+'%')
        elsif method == 'backward'
          Post.where('title LIKE ?', '%'+content)
        else
          Post.where('title LIKE ?', '%'+content+'%')
        end
      end
end
