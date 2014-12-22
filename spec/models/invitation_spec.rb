require "spec_helper"

describe Invitation do 
  it {should validate_presence_of(:recipient_name)}
  it {should validate_presence_of(:recipient_email)}

  it_behaves_like "tokenable" do 
    let(:object) { invitation = Invitation.create(recipient_name: "Joe Smith", recipient_email: "joe@example.com", token: '12345')}
  end 
end  