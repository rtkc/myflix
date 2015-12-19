require 'spec_helper'

feature 'User interacts with queue' do
  scenario 'User adds and reorders videos in queue' do 
    comedy = Fabricate(:category)
    monk = Fabricate(:video, title: 'Monk', category: comedy)
    south_park = Fabricate(:video, title: 'South Park', category: comedy)
    futurama = Fabricate(:video, title: 'Futurama', category: comedy)

    sign_in
    
    add_video_to_queue(monk)
    expect_video_added_to_queue(monk)
    expect_add_my_queue_link_not_visible(monk)

    add_video_to_queue(south_park)
    expect_video_added_to_queue(south_park)
    expect_add_my_queue_link_not_visible(south_park)

    add_video_to_queue(futurama)
    expect_video_added_to_queue(futurama)
    expect_add_my_queue_link_not_visible(futurama)

    visit queue_items_path
    reorder_queue_positions(monk, 3)
    reorder_queue_positions(south_park, 1)
    reorder_queue_positions(futurama, 2)

    expect_queue_items_reordered(monk, 3)
    expect_queue_items_reordered(south_park, 1)
    expect_queue_items_reordered(futurama, 2)
  end 

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    expect(page).to have_content(video.title)
    click_link "+ My Queue"
  end

  def expect_video_added_to_queue(video)
    visit(queue_items_path)
    expect(page).to have_content(video.title)
  end

  def expect_add_my_queue_link_not_visible(video)
    click_link "#{video.title}"
    expect(page).to have_no_content('+ My Queue')
  end

  def reorder_queue_positions(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
    click_button "Update Queue"
  end

  def expect_queue_items_reordered(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end
  
end