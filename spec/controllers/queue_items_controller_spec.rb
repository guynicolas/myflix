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

  describe "POST destroy" do 
    it "redirects to the my queue page" do 
      andy = Fabricate(:user)
      session[:user_id] = andy.id
      queue_item = Fabricate(:queue_item)
      post :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end 
    it "deletes a queue item" do 
      andy = Fabricate(:user)
      session[:user_id] = andy.id
      queue_item = Fabricate(:queue_item, user: andy)
      post :destroy, id: queue_item.id
      expect(andy.queue_items.count).to eq(0)
    end
    it "normalizes the positions of the remaining queue items" do 
      andy = Fabricate(:user)
      session[:user_id] = andy.id
      queue_item1 = Fabricate(:queue_item, user: andy, position: 1)
      queue_item2 = Fabricate(:queue_item, user: andy, position: 2) 
      post :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end 

    it "does not delete a queue item that does not belong to the current user" do 
      andy = Fabricate(:user)
      bob = Fabricate(:user)
      session[:user_id] = andy.id 
      queue_item1 = Fabricate(:queue_item, user: andy)
      queue_item2 = Fabricate(:queue_item, user: bob)
      post :destroy, id: queue_item2.id
      expect(bob.queue_items.count).to eq(1)
    end 
  end 
    it "redirects to the sign in page" do 
      queue_item = Fabricate(:queue_item)
      post :destroy, id: queue_item.id
      expect(response).to redirect_to sign_in_path
    end 
    it "does not delete the queue item" do 
      queue_item = Fabricate(:queue_item)
      post :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end 

  describe "POST update_queue" do 
    context "with valid inputs" do 
      let (:andy) {Fabricate(:user)}
      let (:video) {Fabricate(:video)}
      let(:queue_item1) { Fabricate(:queue_item, user: andy, video: video, position: 1)}
      let(:queue_item2) { Fabricate(:queue_item, user: andy, video: video, position: 2)}

      before {session[:user_id] = andy.id}
      it "redirects to my queue page" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end 
      it "reorders the queue items" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(andy.queue_items).to eq([queue_item2, queue_item1])
      end 
      it "normalizes the position numbers" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 3}]
        expect(andy.queue_items.map(&:position)).to eq([1,2])
      end 
    end 
    context "with invalid inputs" do 
      let (:andy) {Fabricate(:user)}
      let (:video) {Fabricate(:video)}
      let(:queue_item1) { Fabricate(:queue_item, user: andy, video: video, position: 1)}
      let(:queue_item2) { Fabricate(:queue_item, user: andy, video: video, position: 2)}

      before {session[:user_id] = andy.id}
      it "redirects to my queue page" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 3.4}]
        expect(response).to redirect_to my_queue_path
      end 
      it "sets the error message" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 3.4}]
        expect(flash[:danger]).to be_present
      end 
      it "does not change the queue items" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 2.5}]
        expect(queue_item1.reload.position).to eq(1) 
      end 
    end 
    context "with unauthenticated user" do 
      it "redirects to sign in page" do 
        post :update_queue, queue_items: [{id: 1, position: 1}, {id: 2, position: 2}]
        expect(response).to redirect_to sign_in_path
      end 
    end 
    context "with queue items that do not belongs to current user" do 
      it "does not change the queue items" do 
        andy = Fabricate(:user)
        video = Fabricate(:video)
        bob = Fabricate(:user)
        session[:user_id] = andy.id
        queue_item1 = Fabricate(:queue_item, user: bob, video: video, position: 1)
        queue_item2 = Fabricate(:queue_item, user: andy, video: video, position: 2) 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(1) 
      end 
    end 
  end 
end 