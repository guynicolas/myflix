 require 'spec_helper'

describe UsersController do 
  describe 'GET new' do 
    it 'sets @user' do 
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end 
  end 

  describe 'POST create' do 
    context 'successful suer sign up' do 
      it 'redirects to sign in page' do 
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: {email: "andy@example.com", password: "password", full_name: "Andy Carson"}
        expect(response).to redirect_to sign_in_path
      end 
    end 

    context "unsuccessful user sign up" do 
      it "renders the new template" do 
        result = double(:sign_up_result, successful?: false, error_message: "This is an error message.")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: {email: "andy@example.com", password: "password", full_name: "Andy Carson"}, stripeToken: "12341234"
        expect(response).to render_template :new
      end 
      it "sets an error message" do 
        result = double(:sign_up_result, successful?: false, error_message: "This is an error message.")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: {email: "andy@example.com", password: "password", full_name: "Andy Carson"}, stripeToken: "12341234"
        expect(flash[:danger]).to be_present
      end 
    end
  end 

  describe "GET show" do 
    it_behaves_like "requires sign in" do 
      let(:action) { get :show, id: 3}
    end 

    it "sets @user" do 
      set_current_user
      andy = Fabricate(:user)
      get :show, id: andy.id
      expect(assigns(:user)).to eq(andy)
    end 
  end 

  describe "GET new_with_invitation_token" do 
    it "renders the new template" do 
      invitation = Invitation.create(recipient_name: "Joe Smith", recipient_email: "joe@example.com", token: '12345')
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end 
    it "sets @user with recipient's email" do 
      invitation = Invitation.create(recipient_name: "Joe Smith", recipient_email: "joe@example.com", token: '12345')
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end 

    it "sets @invitation_token" do 
      invitation = Invitation.create(recipient_name: "Joe Smith", recipient_email: "joe@example.com", token: '12345')
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end 
    it "redirects to expired token page for invalid token" do 
      get :new_with_invitation_token, token: "12345"
      expect(response).to redirect_to expired_token_path 
    end 
  end 
end 