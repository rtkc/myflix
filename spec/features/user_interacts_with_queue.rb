require 'spec_helper'

feature 'User interacts with queue' do
  scenario 'User adds and reorders videos in queue' do 
    comedy = Fabricate(:category)
    monk = Fabricate(:video, title: 'Monk', category: comedy)
    south_park = Fabricate(:video, title: 'South Park', category: comedy)
    futurama = Fabricate(:video, title: 'Futurama', category: comedy)

    sign_in
    find('/vi/#{monk.id}').click
    expect(page).to have(monk.title)
  end
end