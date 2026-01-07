class Post < ApplicationRecord
    validates :title, presence: true
    validates :body, presence: true
    has_one_attached :image  
    belongs_to :user
    has_many :post_comments, dependent: :destroy
    has_many :post_tags, dependent: :destroy
    has_many :tags, through: :post_tags
    attr_accessor :tag_name


    def save_tags(savepost_tags)
      current_tags = self.tags.pluck(:name) unless self.tags.nil?
      old_tags = current_tags - savepost_tags
      new_tags = savepost_tags - current_tags

      old_tags.each do |old_name|
        self.tags.delete Tag.find_by(name:old_name)
      end
      
      new_tags.each do |new_name|
        tag = Tag.find_or_create_by(name: new_name.strip)
        self.tags << tag unless self.tags.include?(tag)
      end
    end

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
