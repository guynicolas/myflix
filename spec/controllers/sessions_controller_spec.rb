require 'spec_helper'

describe SessionsController do 
  describe 'GET new' do 
    it 'renders the new template for unathentivated users' do 
      get :new
      expect(response).to render_template :new
    end 
    it 'directs authenticated users to home page' do 
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end 
  end 

  describe 'POST create' do 
    context 'with valid crudentials' do 
      before do 
        mike = Fabricate(:user) 
        post :create, email: mike.email, password: mike.password
      end 
      it 'puts the user in session' do 
        mike = Fabricate(:user) 
        post :create, email: mike.email, password: mike.password
        expect(session[:user_id]).to eq(mike.id)
      end 
      it 'sets the notice' do 
        expect(flash[:notice]).not_to be_blank
      end 
      it 'redirects to the home page' do 
        expect(response).to redirect_to home_path
      end 
    end 
    context 'with invalid crudentials' do 
      before do 
        mike = Fabricate(:user) 
        post :create, email: mike.email   
      end 
      it 'does not put the user in session' do 
        expect(session[:user_id]).to be_nil
      end 
      it 'sets the error' do 
        expect(flash[:danger]).to_not be_blank
      end 
      it 'redirects to sign in page' do 
        expect(response).to redirect_to sign_in_path
      end 
    end 
  end 

  describe 'GET destroy' do 
    before do 
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end 
    it 'removes the user from the session' do 
      expect(session[:user_id]).to be_nil
    end 
    it 'sets the notice' do 
      expect(flash[:notice]).not_to be_blank
    end 
    it 'redirects to the root path' do 
      expect(response).to redirect_to root_path
    end 
  end 
end 