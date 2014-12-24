 class Video < ActiveRecord::Base 
  belongs_to :category
  has_many :reviews, -> {order("created_at DESC")}

  mount_uploader :large_cover, LargeCoverUploader 
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description

  before_save :generate_slug!

  def to_param
    self.slug
  end

  def generate_slug!
    self.slug = self.title.gsub(' ', '-').downcase
  end

  def title_only?
    description.blank?
  end

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?",  "%#{search_term}%").order("created_at DESC")
  end

  def average_rating
   reviews.average(:rating).round(1) if reviews.average(:rating)
  end 
end  
