class Tag < ApplicationRecord
    has_many :post_tags,dependent: :destroy, foreign_key: 'tag_id'
    has_many :posts,through: :post_tags
    
    validates :name, uniqueness: true, presence: true
    scope :merge_books, -> (tags){ }
  
    def self.search_posts_for(content, method)
      
      if method == 'perfect'
        tags = Tag.where(name: content)
      elsif method == 'forward'
        tags = Tag.where('name LIKE ?', content + '%')
      elsif method == 'backward'
        tags = Tag.where('name LIKE ?', '%' + content)
      else
        tags = Tag.where('name LIKE ?', '%' + content + '%')
      end
      
      Post.joins(:tags).where(tags: { id: tags.pluck(:id) }).distinct
      
    end
  end