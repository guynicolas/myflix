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
      after { ActionMailer::Base.deliveries.clear}
      it 'sets @user' do 
        expect(User.count).to eq(1)
      end 
      it 'redirects to sign in page' do 
        expect(response).to redirect_to sign_in_path
      end 
      it "sends out a welcome email to the user" do 
        post :create, user: {email: "andy@example.com", password: "password", full_name: "Andy Carson"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["andy@example.com"])
      end 
      it "sends out a welcome email containing the user's name" do 
        post :create, user: {email: "andy@example.com", password: "password", full_name: "Andy Carson"}
        expect(ActionMailer::Base.deliveries.last.body).to include("Andy Carson")
      end 

      it "makes the user follow the inviter" do 
        andy = Fabricate(:user)
        invitation = Invitation.create(inviter: andy, recipient_name: "Joe Smith", recipient_email: "joe@example.com", token: '12345')
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Smith"}, invitation_token: invitation.token
        joe = User.where(email: "joe@example.com").first
         expect(joe.follows?(andy)).to be_truthy  
      end
      it "makes the inviter follow the user" do 
        andy = Fabricate(:user)
        invitation = Invitation.create(inviter: andy, recipient_name: "Joe Smith", recipient_email: "joe@example.com", token: '12345')
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Smith"}, invitation_token: invitation.token
        joe = User.where(email: "joe@example.com").first
        expect(andy.follows?(joe)).to be_truthy   
      end 
      it "expires the invitation token upon acceptance" do 
        andy = Fabricate(:user)
        invitation = Invitation.create(inviter: andy, recipient_name: "Joe Smith", recipient_email: "joe@example.com", token: '12345')
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Smith"}, invitation_token: invitation.token
        joe = User.where(email: "joe@example.com").first
        expect(Invitation.first.token).to be_nil  
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
      it "does not send out welcome email" do 
        post :create, user: {email: "andy@example.com", password: "password"}
        expect(ActionMailer::Base.deliveries).to be_empty
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
