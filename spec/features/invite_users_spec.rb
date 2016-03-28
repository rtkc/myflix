require 'spec_helper' 

feature 'invite users', { js: true, vcr: true } do 
  scenario 'existing user sends invit and invitee registers' do 
    alice = Fabricate(:user)

    sign_in(alice)
    visit new_invitation_path

    fill_in "Friend's name", with: "Jim Tealeaf"
    fill_in "Friend's email", with: "Jim@email.com"
    click_button "Send Invitation"
    expect(page).to have_content("Your inviitation was successfully sent.")

    open_email("Jim@email.com")
    current_email.click_link("Accept Invitation")
    
    expect(page).to have_content("Register")
    fill_in "Full Name", with: "Jim Tealeaf"
    fill_in "Password", with: "12345"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "12 - December",from: "date_month"
    select "2018", from: "date_year"
    click_button 'Sign Up'

    expect(page).to have_content("You have signed up successfully")

    visit people_path
    expect(page).to have_content(alice.full_name)
  end
end