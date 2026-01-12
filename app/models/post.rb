class Post < ApplicationRecord
    validates :title, presence: true
    validates :body, presence: true
    validates :comedian_name, presence: true
    has_one_attached :image  
    belongs_to :user
    has_many :post_comments, dependent: :destroy
    has_many :post_tags, dependent: :destroy
    has_many :tags, through: :post_tags
    has_many :favorites, dependent: :destroy
    attr_accessor :tag_name
    scope :latest, -> {order(created_at: :desc)}
    scope :old, -> {order(created_at: :asc)}
    scope :rate, -> {order(rate: :desc)}
    scope :favorites_count, -> {
      left_joins(:favorites)
      .group(:id)
      .order('COUNT(favorites.id) DESC')
    }


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

    def favorited_by?(user)
      return false if user.nil?
      favorites.where(user_id: user.id).exists?
    end

    def self.search_for(content, method)
      if method == 'perfect'
        where('comedian_name = :content OR title = :content OR body = :content', content: content)
      elsif method == 'forward'
        where('comedian_name LIKE :content OR title LIKE :content OR body LIKE :content', content: "#{content}%")
      elsif method == 'backward'
        where('comedian_name LIKE :content OR title LIKE :content OR body LIKE :content', content: "%#{content}")
      else
        where('comedian_name LIKE :content OR title LIKE :content OR body LIKE :content', content: "%#{content}%")
      end
    end
end
