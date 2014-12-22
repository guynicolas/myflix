require 'spec_helper'

describe InvitationsController do 
  describe "GET new" do 
    it_behaves_like 'requires sign in'  do 
      let(:action) {get :new}
    end 
    it "sets @invitation to new invitation" do 
      set_current_user
      get :new 
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end 
  end 

  describe "POST create" do 
    it_behaves_like "requires sign in" do 
      let(:action) {post :create}
    end 

    context 'with valid inputs' do

      after { ActionMailer::Base.deliveries.clear }

      it 'redirects to the new invitation page' do 
        set_current_user  
        post :create, invitation: {recipient_name: "Ben Carson", recipient_email: "ben@example.com", message: "Please join this cool site!"}
        expect(response).to redirect_to new_invitation_path
      end 
      it "creates an invitation" do 
        set_current_user
        post :create, invitation: {recipient_name: "Ben Carson", recipient_email: "ben@example.com", message: "Please join this cool site!"}
        expect(Invitation.count).to eq(1)
      end 
      it "sends an email to the recipient" do 
        set_current_user
        post :create, invitation: {recipient_name: "Ben Carson", recipient_email: "ben@example.com", message: "Please join this cool site!"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["ben@example.com"])
      end 
      it "shows a success message" do 
        set_current_user
        post :create, invitation: {recipient_name: "Ben Carson", recipient_email: "ben@example.com", message: "Please join this cool site!"}
        expect(flash[:success]).to be_present
      end 
    end 

    context 'with invalid inputs' do 
      it "renders the new template" do 
        set_current_user
        post :create, invitation: {recipient_name: "Ben Carson" }
        expect(response).to render_template :new 
      end 
      it "does not create an invitation" do 
        set_current_user
        post :create, invitation: {recipient_name: "Ben Carson" }
        expect(Invitation.count).to eq(0)
      end 
      it "does not send an invitation email" do 
        set_current_user
        post :create, invitation: {recipient_name: "Ben Carson"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end 
      it "shows an erroe message" do 
        set_current_user
        post :create, invitation: {recipient_name: "Ben Carson"}
        expect(flash[:danger]).to be_present       
      end 
      it "sets the @invitation" do 
        set_current_user
        post :create, invitation: {recipient_name: "Ben Carson" }
        expect(assigns(:invitation)).to be_present
      end 
    end
  end 
end 