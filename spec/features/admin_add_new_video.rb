require "spec_helper" 

feature "Admin adds new video" do 
  scenario "Admin successfully adds new video" do 
    admin = Fabricate(:admin)
    sign_in(admin)
    dramas = Fabricate(:category, name: "Dramas")
    visit new_admin_video_path

    fill_in "Title", with: "Monk"
    select "Dramas", from: "Category"
    fill_in "Description", with: "Great Show!"
    attach_file "Large Cover", 'spec/support/uploads/monk_large.jpg'
    attach_file "Small Cover", 'spec/support/uploads/monk.jpg'
    fill_in "Video URL", with: 'www.example.com/my_video.mp4'
    click_button 'Add Video'

    sign_out
    sign_in
  end 
end 