require 'spec_helper'

feature 'User resets password' do 
  scenario 'user successfully resets the password' do 
    andy = Fabricate(:user, password: 'old_password')
    visit sign_in_path 
    click_link 'Forgot Password?'
    fill_in "Email Address", with: andy.email
    click_button 'Send Email'

    open_email(andy.email)
    current_email.click_link('Reset My Password')

    fill_in "New Password", with: 'new_password'

    click_button 'Reset Password'

    fill_in 'Email Address', with: andy.email
    fill_in 'Password', with: 'new_password'

    click_button 'Sign In'
    page.should have_content "Welcome to MyFlix, #{andy.full_name}!"
 
  end 
end