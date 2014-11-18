require 'spec_helper'

describe User do 
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }

end 
describe "#queued_video?" do 
  it "returns true when the user has added the video in the queue" do 
    andy = Fabricate(:user)
    futurama = Fabricate(:video)
    queue_item = Fabricate(:queue_item, video: futurama, user: andy)
    expect(andy.queued_video?(futurama)).to be_true
  end 
  it "returns false when the user has not added the video in teh queue" do 
    andy = Fabricate(:user)
    futurama = Fabricate(:video)
    expect(andy.queued_video?(futurama)).to be_false
  end 
end 