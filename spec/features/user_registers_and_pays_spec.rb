require "spec_helper" 
feature "user registration and payment" , { js: true, vcr: true } do 
  background do 
    visit register_path 
  end 
  scenario "user provides valid personal info and valid card info" do 
    fill_in_valid_user_info
    fill_in_valid_card_info          
    click_button "Sign Up"   
    page.should have_content "Welcome to MyFLix."
  end 

  scenario "user provides valid personal info and invalid card info" do 
    fill_in_valid_user_info
    fill_in_invalid_card_info
    click_button "Sign Up" 
    page.should have_content "Your card number is incorrect."
  end 

  scenario "user provides valid personal info and a declined card" do 
    fill_in_valid_user_info
    fill_in_declined_card_info
    click_button "Sign Up" 
    page.should have_content "Your card was declined."
  end 

  scenario "user provides invalid personal info and valid card info" do 
    fill_in_invalid_user_info
    fill_in_valid_card_info
    click_button "Sign Up"
    page.should have_content "You are enable to register. Correct the errors and try again."
  end 

  scenario "user provides invalid personal info and invalid card info" do 
    fill_in_invalid_user_info
    fill_in_invalid_card_info
    click_button "Sign Up"  
    page.should have_content "This card number looks invalid"
  end 

  scenario "user provides invalid personal info and a decline card" do 
    fill_in_invalid_user_info
    fill_in_declined_card_info
    click_button "Sign Up"  
    page.should have_content "You are enable to register. Correct the errors and try again."
  end

  def fill_in_valid_user_info
    fill_in "Email Address",         with: "ben@example.com"
    fill_in "Password",              with: "password"
    fill_in "Full Name",             with: "Ben Carson"    
  end
  def fill_in_invalid_user_info
    fill_in "Password",             with: "password"
    fill_in "Full Name",            with: "Ben Carson"
  end
  def fill_in_valid_card_info 
    fill_in "Credit Card Number",   with: "4242424242424242"
    fill_in "Security Code",        with: "314" 
    select "12 - December",         from: "date_month"
    select "2017",                  from: "date_year"
  end
  def fill_in_declined_card_info
    fill_in "Credit Card Number",   with: "4000000000000002"
    fill_in "Security Code",        with: "314"
    select "12 - December",         from: "date_month"
    select "2017",                  from: "date_year"
  end
  def fill_in_invalid_card_info
    fill_in "Credit Card Number",   with: "4242424242424241"
    fill_in "Security Code",        with: "314"
    select "12 - December",         from: "date_month"
    select "2017",                  from: "date_year"
  end
end 