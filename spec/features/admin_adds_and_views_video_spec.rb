require 'spec_helper' 

feature "add video" do 
  scenario "Log in as admin, add video, view successfully added video" do 
    jim = Fabricate(:admin)
    drama = Fabricate(:category, name: 'Drama')
    sign_in(jim)

    visit new_admin_video_path

    fill_in "Title", with: "Sherlock"
    select "Drama", from: "Category"
    fill_in "Description", with: "Benedict Cumberbatch"
    attach_file "Large image", "spec/support/uploads/monk_large.jpg"
    attach_file "Small image", "spec/support/uploads/monk.jpg"
    fill_in "Link to a video", with: "http://example.com/myvid.mp4"
    click_button "Add video"

    expect(page).to have_content "You have successfully added the video Sherlock."

    sign_out

    sign_in
    visit video_path(Video.first)
    expect(page).to have_content "Sherlock"
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://example.com/myvid.mp4']")

  end
end