require "spec_helper"

describe PasswordResetsController do 
  describe "GET show" do 
    it "renders show template if the token is valid" do 
      andy = Fabricate(:user)
      andy.update_column(:token, "12345")
      get :show, id: '12345'
      expect(response).to render_template :show
    end 
    it "redirects to the expired token page if the token is invalid" do
      get :show, id: "12345"
      expect(response).to redirect_to expired_token_path
    end 

    it "sets a token" do 
      andy = Fabricate(:user)
      andy.update_column(:token, "12345")
      get :show, id: '12345'
      expect(assigns(:token)).to eq("12345")
    end   
  end 

  describe "POST create" do 
    context "with valid token" do 
      it "redirects to the sign in page" do 
        andy = Fabricate(:user, password: 'old_password')
        andy.update_column(:token, "12345")
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to sign_in_path
      end 
      it "update the user's password" do 
        andy = Fabricate(:user, password: 'old_password')
        andy.update_column(:token, "12345")
        post :create, token: '12345', password: 'new_password'
        expect(andy.reload.authenticate('new_password')).to be_truthy
      end 
      it "sets the flash success message" do 
        andy = Fabricate(:user, password: 'old_password')
        andy.update_column(:token, "12345")
        post :create, token: '12345', password: 'new_password'
        expect(flash[:success]).to be_present
      end 
      it  "regenerates the user's token" do 
        andy = Fabricate(:user, password: 'old_password')
        andy.update_column(:token, "12345")
        post :create, token: '12345', password: 'new_password'
        expect(andy.reload.token).not_to eq('12345')
      end 
    end 

    context "with invalid token" do 
      it "redirects to the expired token page" do 
        post :create, token: '12345', password: 'some_password'
        expect(response).to redirect_to expired_token_path
      end  
    end 
  end 
end 