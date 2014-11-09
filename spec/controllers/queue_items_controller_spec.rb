require "spec_helper"

describe QueueItemsController do
  describe 'GET index' do 
    it "sets @queue_items to the queue items of the logged in user" do 
      andy = Fabricate(:user)
      session[:user_id] = andy.id
      queue_item1 = Fabricate(:queue_item, user: andy)
      queue_item2 = Fabricate(:queue_item, user: andy)
      get :index 
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end 
    it "redirects unauthenticated users to sign in page" do 
      get :index 
      expect(response).to redirect_to sign_in_path
    end 
  end 

  describe "POST create" do 
    it "redirects authenticated users to my queue page" do 
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end 
    it "creates a queue item" do 
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end 
    it "creates a queue item associated with the video" do 
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end 
    it "creates a queue item associated with the current user" do 
      mike = Fabricate(:user)
      session[:user_id] = mike.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(mike)
    end 
    it "puts the video in the last position in the queue" do 
      mike = Fabricate(:user)
      session[:user_id] = mike.id
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: mike)
      futurama = Fabricate(:video)
      post :create, video_id: futurama.id
      futurama_queue_item = QueueItem.where(video_id: futurama.id, user_id: mike.id).first
      expect(futurama_queue_item.position).to eq(2)
    end 
    it "does not create a queue item if the video is already in the queue" do 
      mike = Fabricate(:user)
      session[:user_id] = mike.id
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: mike)
      post :create, video_id: monk.id
      expect(mike.queue_items.count).to eq(1)
    end 
    it "redirects unauthenticated users to the sign in page" do 
      post :create, video_id: 24
      expect(response).to redirect_to sign_in_path
    end 
  end 
end 
