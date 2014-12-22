require 'spec_helper'

describe Category do 
  it { should have_many(:videos)}
  it { should validate_presence_of(:name)}


  describe "#recent_videos" do 
    it "returns videos in reverse chronological order by created_at" do 
      tv_comedies = Category.create(name: "TV Comedies")
      futurama = Video.create(title: "Futurama", description: "Funny stuff", category: tv_comedies, created_at: 1.day.ago)
      south_park = Video.create(title: "South Park", description: "Hilarious", category: tv_comedies)
      expect(tv_comedies.recent_videos).to eq([south_park, futurama]) 
    end 
    it "returns all videos if there are less than 6 videos" do 
      tv_comedies = Category.create(name: "TV Comedies")
      futurama = Video.create(title: "Futurama", description: "Funny stuff", category: tv_comedies, created_at: 1.day.ago)
      south_park = Video.create(title: "South Park", description: "Hilarious", category: tv_comedies)
      expect(tv_comedies.recent_videos.count).to eq(2) 
    end 
    it "returns 6 videos if there are more than 6 videos" do 
      tv_comedies = Category.create(name: "TV Comedies")
      10.times {Video.create(title: "Bean", description: "Crazy guy", category: tv_comedies)}
      expect(tv_comedies.recent_videos.count).to eq(6)
    end 
    it "returns the most recent 6 videos" do 
      tv_comedies = Category.create(name: "TV Comedies")
      6.times {Video.create(title: "Bean", description: "Crazy guy", category: tv_comedies)}
      tonight_show = Video.create(title: "Tonight Show", description: "Talk Show", category: tv_comedies, created_at: 1.day.ago)
      expect(tv_comedies.recent_videos).not_to include(tonight_show)
    end 
    it "returns an empty array if the category does not have any videos" do 
    tv_comedies = Category.create(name: "TV Comedies")
    expect(tv_comedies.recent_videos).to eq([])
    end 
  end 
end 
