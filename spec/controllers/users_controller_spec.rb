require 'spec_helper'

describe UsersController do 
  describe 'GET new' do 
    it 'sets @user' do 
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end 
  end 
  describe 'POST create' do 
    context 'for valid inputs' do 
      before do 
        post :create, user: Fabricate.attributes_for(:user)
      end 
      it 'sets @user' do 
        expect(User.count).to eq(1)
      end 
      it 'redirects to sign in page' do 
        expect(response).to redirect_to sign_in_path
      end 
    end 
    context 'for invalid inputs' do 
      before do 
        post :create, user: {email: 'joe@example.com', password: 'password'}
      end 
      it 'does not set @user' do 
        expect(User.count).to eq(0)
      end 
      it 'renders the new template' do 
        expect(response).to render_template :new
      end 
    end 
  end 
end 