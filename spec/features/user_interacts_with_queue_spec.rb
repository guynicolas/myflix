require 'spec_helper' 

feature 'user interacts with the queue' do 
  scenario 'user adds and reorders videos in the queue' do 

    comedies = Fabricate(:category, name: "Comedies")

    monk = Fabricate(:video, title: "Monk", category: comedies)
    futurama = Fabricate(:video, title: "Futurama", category: comedies)
    south_park = Fabricate(:video, title: "South Park", category: comedies)

    sign_in

    add_video_to_queue(monk)
    expect_video_to_be_in_queue(monk)

    visit video_path(monk)
    expect_text_not_to_be_seen("+ My Queue")
    
    add_video_to_queue(futurama)
    add_video_to_queue(south_park) 

    set_video_position(monk, 3)
    set_video_position(futurama, 1)
    set_video_position(south_park, 2)

    update_queue

    expect_video_position(monk, 3)
    expect_video_position(futurama, 1)
    expect_video_position(south_park, 2)
  end 

  def expect_text_not_to_be_seen(link_text)
    page.should_not have_content(link_text)
  end

  def expect_video_to_be_in_queue(video)
    page.should have_content(video.title)
  end

  def add_video_to_queue(video)
    visit home_path 
    find("a[href='/videos/#{video.slug}']").click
    click_link "+ My Queue"
  end

  def update_queue
     click_button "Update Instant Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do 
      fill_in "queue_items[][position]", with: position
    end 
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end
end   

    # find("input[data-video-id='#{monk.id}']").set(3)
    # find("input[data-video-id='#{futurama.id}']").set(1)
    # find("input[data-video-id='#{south_park.id}']").set(2)

    # expect(find("input[data-video-id='#{monk.id}']").value).to eq(3.to_s)
    # expect(find("input[data-video-id='#{futurama.id}']").value).to eq(1.to_s)
    # expect(find("input[data-video-id='#{south_park.id}']").value).to eq(2.to_s)