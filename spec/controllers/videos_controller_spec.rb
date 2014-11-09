require 'spec_helper' 

describe VideosController do 
  describe 'GET index' do 
    it 'sets @videos for authenticated users' do 
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: "Futurama") 
      family_guy = Fabricate(:video, title: "Family Guy")

      get :index 
      expect(assigns(:videos)).to eq([futurama, family_guy])
    end 
  end 

  describe 'GET show' do 
    it 'sets @video for authenticated users' do 
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video, title: "Futurama") 
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end 
    it 'set @reviews for authenticated users' do 
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end 
    it 'redirects unauthenticated users to sign in page' do 
      video = Fabricate(:video, title: "Futurama") 
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end 
  end 
  describe 'POST search' do 
    it 'sets @results for authenticated users' do 
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: "Futurama") 
      get :search, search_term: 'rama'
      expect(assigns(:results)).to eq([futurama])
    end 
    it 'redirects to sign in page' do 
      futurama = Fabricate(:video, title: "Futurama") 
      get :search, search_term: 'rama'
      expect(response).to redirect_to sign_in_path
    end 
  end 
end 