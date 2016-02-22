require 'spec_helper' 

feature 'follow and unfollow user' do 
  scenario 'User adds and removes another user from the list of peole they follow' do 
    jim = Fabricate(:user)
    alice = Fabricate(:user)
    comedy = Fabricate(:category)
    video = Fabricate(:video, category: comedy)
    review = Fabricate(:review, video: video, creator: alice)

    sign_in(jim)
    visit home_path
    click_on_video_on_home_page(video)

    click_link alice.full_name
    click_link("Follow")

    visit people_path
    expect(page).to have_content(alice.full_name)

    unfollow(alice)
    expect(page).not_to have_content(alice.full_name)
  end

  def unfollow(leader)
    find("a[data-method='delete']").click
  end
end