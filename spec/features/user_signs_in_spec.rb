require 'spec_helper'

feature 'user signs in' do 
  scenario "with valid email and password" do 
    andy = Fabricate(:user)
    sign_in(andy) 
    page.should have_content "You are signed in, Welcome!"
  end 
end