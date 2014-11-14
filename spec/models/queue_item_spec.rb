require "spec_helper" 

describe QueueItem do 
  it { should belong_to(:user)}
  it { should belong_to(:video)}
  it { should validate_numericality_of(:position).only_integer}

  describe "#video_title" do 
    it "returns the title of the associated video" do 
      video = Fabricate(:video, title: "Monk")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Monk")
    end 
  end 

  describe "#rating" do 
    it "returns the rating from an existing review" do 
      video   = Fabricate(:video)
      user    = Fabricate(:user)
      review  = Fabricate(:review, video: video, user: user, rating: 4)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(4)
    end 
    it "retuns nil for a non-exisitng review" do 
      video   = Fabricate(:video)
      user    = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(nil)
    end 
  end 

  describe "#rating=" do 
    it "changes the rating if the review is present"  do 
      andy = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: andy, video: video, rating: 3)
      queue_item = Fabricate(:queue_item, user: andy, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end 
    it "clears the rating of the review if the review is present" do 
      andy = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: andy, video: video, rating: 3)
      queue_item = Fabricate(:queue_item, user: andy, video: video)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end 
    it "it creates a review with a rating if the review is not present" do 
      andy = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: andy, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end 
  end 

  describe "#category_name" do 
    it "returns the name of the associated video's category" do 
      category = Fabricate(:category, name: "Comedies")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Comedies")
    end 
  end 

  describe "#category" do 
    it "returns the category of the associated video" do 
      category = Fabricate(:category, name: "Comedies")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end 
  end 
end 