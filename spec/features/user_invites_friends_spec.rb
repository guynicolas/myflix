require "spec_helper"

feature "user invites friends" do 
  scenario "user successfully invites a friend and the invitation is accepted" do 

    andy = Fabricate(:user)

    sign_in(andy)

    visit new_invitation_path

    fill_in "Friend's Name", with: "Ben Carson"
    fill_in "Friend's Email", with: "ben@example.com"
    fill_in "Invitation Message", with: "Please join MyFlix!"
    click_button "Send Invitation"
    sign_out 

    open_email("ben@example.com")
    current_email.click_link("Accept this invitation")

    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Ben Carson"
    click_button "Sign Up"
  

    fill_in "Email Address", with: "ben@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"

    click_link "People"
    expect(page).to have_content andy.full_name 
    sign_out 

    sign_in(andy)
    click_link "People"
    expect(page).to have_content "Ben Carson"

  end 
end 