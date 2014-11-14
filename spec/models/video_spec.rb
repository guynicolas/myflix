require 'spec_helper'

describe Video do 
  it {should belong_to(:category)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}
  it {should have_many(:reviews).order("created_at DESC")}
end 


describe "#title_only?" do 
  it "returns true when description is nil" do 
    video = Video.new(title: "Futurama")
    video.title_only?.should be true
  end 
  it "returns true when description is an empty string" do 
    video = Video.new(title: "Futurama", description: "")
    video.title_only?.should be true
  end 
  it "returns false when description is an non empty string" do 
    video = Video.new(title: "Futurama", description: "Funny")
    video.title_only?.should be false
  end 
end

describe "search_by_title" do 
  it "returns an empty array if there is no match" do 
    furutama = Video.create(title: "Futurama", description: "Space travel")
    back_to_future = Video.create(title: "Back to Future", description: "Time travel")
    expect(Video.search_by_title("hello")).to eq([])
  end 

  it "returns an array of one video for an exact match" do 
    furutama = Video.create(title: "Futurama", description: "Space travel")
    back_to_future = Video.create(title: "Back to Future", description: "Time travel")
    expect(Video.search_by_title("Futurama")).to eq([furutama])
  end 

  it "returns an array of one video for a partial match" do 
    furutama = Video.create(title: "Futurama", description: "Space travel")
    back_to_future = Video.create(title: "Back to Future", description: "Time travel")
    expect(Video.search_by_title("urama")).to eq([furutama])
  end 

  it "returns an array of many videos for multiple matches ordered by created_at" do 
    furutama = Video.create(title: "Futurama", description: "Space travel", created_at: 1.day.ago)
    back_to_future = Video.create(title: "Back to Future", description: "Time travel")
    expect(Video.search_by_title("Futur")).to eq([back_to_future, furutama])
  end 

  it "returns an empty array for a search with an empy string" do 
    furutama = Video.create(title: "Futurama", description: "Space travel", created_at: 1.day.ago)
    back_to_future = Video.create(title: "Back to Future", description: "Time travel")
    expect(Video.search_by_title("")).to eq([])
  end 
end 

describe "#average_rating" do 
  it "returns nil when the video has no reviews" do 
    futurama = Video.create(title: "Futurama", description: "Space travel")
    expect(futurama.average_rating).to be_nil
  end 
  it "returns one rating when the video has one review" do 
    futurama = Video.create(title: "Futurama", description: "Space travel")
    review = Review.create(rating: 4.0, content: "Good movie", video: futurama)
    expect(futurama.average_rating).to eq(4)
  end 
  it "returns the average rating when the video has many reviews" do 
    futurama = Video.create(title: "Futurama", description: "Space travel")
    review1 = Review.create(rating: 4.0, content: "Good movie", video: futurama)
    review2 = Review.create(rating: 3.0, content: "Fine movie", video: futurama)
    expect(futurama.average_rating).to eq(3.5)
  end 
end 