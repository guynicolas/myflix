require 'spec_helper'

describe User do 
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it {should have_many(:queue_items).order('position')}
  it {should have_many(:reviews).order("created_at DESC")}

  it_behaves_like "tokenable" do 
    let(:object) { Fabricate(:user) }
  end  

  describe "#queued_video?" do 
    it "returns true when the user has added the video in the queue" do 
      andy = Fabricate(:user)
      futurama = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: futurama, user: andy)
      expect(andy.queued_video?(futurama)).to be_truthy
    end 
    it "returns false when the user has not added the video in teh queue" do 
      andy = Fabricate(:user)
      futurama = Fabricate(:video)
      expect(andy.queued_video?(futurama)).to be_falsey
    end 
  end 

  describe "#follows?" do 
    it "returns true if the current user already follows the leader" do 
      andy = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: andy)
      expect(andy.follows?(bob)).to be_truthy
    end 
    it "returns false if the current user does not follow the leader" do 
      andy = Fabricate(:user)
      bob = Fabricate(:user)
      clara = Fabricate(:user)
      Fabricate(:relationship, leader: clara, follower: andy)
      expect(andy.follows?(bob)).to be_falsey
    end 
  end 

  describe "#follow" do
    it "follows another user" do
      andy = Fabricate(:user)
      ben = Fabricate(:user)
      andy.follow(ben)
      expect(andy.follows?(ben)).to be_truthy
    end 
    it "does not follow oneself" do
      andy = Fabricate(:user)
      andy.follow(andy)
      expect(andy.follows?(andy)).to be_falsey
    end 
  end 
end 