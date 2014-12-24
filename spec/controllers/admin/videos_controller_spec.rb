require "spec_helper"

describe Admin::VideosController do 
  describe "GET new" do 
    it_behaves_like "requires sign in" do 
      let(:action) {get :new}
    end 
    it "sets the @video to a new vide" do 
      set_current_admin
      get :new
      expect(assigns(:video)).to be_new_record
      expect(assigns(:video)).to be_instance_of Video 
    end 
    it "redirects regular users to home path" do 
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end 
    it "sets a flahsh error message for regular user" do 
      set_current_user
      get :new
      expect(flash[:danger]).to be_present 
    end 
  end 

  describe "POST create" do 
    it_behaves_like "requires sign in" do 
      let(:action) { post :create }
    end 
    it_behaves_like "requires admin" do 
      let(:action) { post :create }
    end 
    context 'with valid input' do 
      it "redirects admin to the new video path" do 
        category = Category.create(name: "TV Comedies")
        set_current_admin
        post :create, video: {title: "Futurama", category_id: category.id, description: "Great show!"}
        expect(response).to redirect_to new_admin_video_path
      end 
      it "creates a video" do 
        category = Category.create(name: "TV Comedies")
        set_current_admin
        post :create, video: {title: "Futurama", category_id: category.id, description: "Great show!"}
        expect(category.videos.count).to eq(1)
      end 
      it "sets a success message" do 
        category = Category.create(name: "TV Comedies")
        set_current_admin
        post :create, video: {title: "Futurama", category_id: category.id, description: "Great show!"}
        expect(flash[:success]).to be_present  
      end 
    end 
    context 'with invalid input' do 
      it "render the new template" do 
        category = Category.create(name: "TV Comedies")
        set_current_admin
        post :create, video: { category_id: category.id, description: "Great show!"}
        expect(response).to render_template :new 
      end 
      it "does not create a video" do 
        category = Category.create(name: "TV Comedies")
        set_current_admin
        post :create, video: { category_id: category.id, description: "Great show!"}
        expect(category.videos.count).to eq(0)
      end 
      it "sets an error message" do 
        category = Category.create(name: "TV Comedies")
        set_current_admin
        post :create, video: { category_id: category.id, description: "Great show!"}
        expect(flash[:danger]).to be_present  
      end 
      it "sets the @video" do 
        category = Category.create(name: "TV Comedies")
        set_current_admin
        post :create, video: { category_id: category.id, description: "Great show!"}
        expect(assigns(:video)).to be_present        
      end 
    end 
  end 
end 