require "spec_helper"

describe UserSignup do 
  describe "#sign_up" do 
    context "valid personal info and valid card" do 
      let(:charge) { double(:charge, successful?: true )}
      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }
      after { ActionMailer::Base.deliveries.clear}
      it 'creates a user' do 
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "Joe Smith")).sign_up("stripe_token", nil)
        expect(User.count).to eq(1)
      end 
      it "makes the user follow the inviter" do 
        andy = Fabricate(:user)
        invitation = Invitation.create(inviter: andy, recipient_name: "Joe Smith", recipient_email: "joe@example.com", token: '12345')
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "Joe Smith")).sign_up("stripe_token", invitation.token)
        joe = User.where(email: "joe@example.com").first
        expect(joe.follows?(andy)).to be_truthy  
      end
      it "makes the inviter follow the user" do 
        andy = Fabricate(:user)
        invitation = Invitation.create(inviter: andy, recipient_name: "Joe Smith", recipient_email: "joe@example.com", token: '12345')
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "Joe Smith")).sign_up("stripe_token", invitation.token)
        joe = User.where(email: "joe@example.com").first
        expect(andy.follows?(joe)).to be_truthy   
      end 
      it "expires the invitation token upon acceptance" do 
        andy = Fabricate(:user)
        invitation = Invitation.create(inviter: andy, recipient_name: "Joe Smith", recipient_email: "joe@example.com", token: '12345')
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "Joe Smith")).sign_up("stripe_token", invitation.token)
        joe = User.where(email: "joe@example.com").first
        expect(Invitation.first.token).to be_nil  
      end 
      it "sends out a welcome email to the user" do 
        UserSignup.new(Fabricate.build(:user, email: "andy@example.com")).sign_up("stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["andy@example.com"])
      end 
      it "sends out a welcome email containing the user's name" do 
        UserSignup.new(Fabricate.build(:user, full_name: "Andy Carson", email: "andy@example.com")).sign_up("stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Andy Carson")
      end 
    end 

    context "valid personal info and declined card" do 
      it "does not create a user" do 
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
      end 
    end 

    context 'invalid personal information' do 
      let(:charge) { double(:charge, successful?: false )}
      before { StripeWrapper::Charge.should_not_receive(:create) }
      it 'does not set @user' do 
        UserSignup.new(User.new( email: "andy@example.com")).sign_up("stripe_token", nil)
        expect(User.count).to eq(0) 
      end 
      it "does not send out welcome email" do 
        UserSignup.new(User.new( email: "andy@example.com")).sign_up("stripe_token", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it "does not charge the card" do 
        UserSignup.new(User.new( email: "andy@example.com")).sign_up("stripe_token", nil)
      end 
    end 
  end 
end 