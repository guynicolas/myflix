require "spec_helper"

feature "user following" do 
  scenario "user follows and unfolows people" do 
    frank = User.create(full_name: "Frank Underwood", email: "frank@homeland.com", password: "ruthless")
    comedies = Fabricate(:category, name: "Comedies")
    futurama = Fabricate(:video, title: "Futurama", category: comedies)
    review = Fabricate(:review, user: frank, video: futurama)
    
    sign_in 

    click_on_video_on_home_page(futurama)

    click_link(frank.full_name)

    click_link("Follow")
    page.should have_content(frank.full_name) 

    unfollow(frank)
    expect(page).not_to have_content(frank.full_name) 

    def unfollow(user)
      find("a[data-method='delete']").click 
    end
  end 
end 
