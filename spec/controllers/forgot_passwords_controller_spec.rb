require 'spec_helper'

describe ForgotPasswordsController do 
  describe "POST create" do
    context 'with blank input' do 
      it "redirects to the forgot password page" do 
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end 

      it "shows an error message" do 
        post :create, email: ""
        expect(flash[:danger]).to eq("Email cannot be blank.")
      end 
    end 
    context 'with existing email' do 
      after { ActionMailer::Base.deliveries.clear }
      it "redirects to the forgot password confirmation page" do 
        andy = Fabricate(:user, email: "andy@example.com")
        post :create, email: andy.email
        expect(response).to redirect_to forgot_password_confirmation_path
      end 
      it "sends a confirmation email to the user's email" do 
        andy = Fabricate(:user, email: "andy@example.com")
        post :create, email: andy.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([andy.email])
      end 
    end 
    context 'with non-existing email' do 
      it "redirects to the forgot password page" do 
        post :create, email: "carson@example.com"
        expect(response).to redirect_to forgot_password_path
      end 
      it "shows an error message" do 
        post :create, email: "carson@example.com"
        expect(flash[:danger]).to eq("No user with that email found in our system.")
      end 
    end 
  end  
end 