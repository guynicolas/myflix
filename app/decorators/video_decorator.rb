class VideoDecorator < Draper::Decorator 
  delegate_all 
  def average_rating 
    "#{object.average_rating}/5.0"  if object.average_rating
  end
end 