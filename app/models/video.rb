class Video < ActiveRecord::Base 
  belongs_to :category
  has_many :reviews, -> {order("created_at DESC")}

  validates_presence_of :title, :description

  def title_only?
    description.blank?
  end

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?",  "%#{search_term}%").order("created_at DESC")
  end

  def average_rating
    video_rating = (reviews.all.map(&:rating).sum.to_f / reviews.count).round(1)
    "Rating: #{video_rating}/5.0" if reviews.any? 
  end 
end  