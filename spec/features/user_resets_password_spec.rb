require 'spec_helper'

feature 'reset password' do 
  scenario 'User requests link to reset password and successfully resets password' do
     alice = Fabricate(:user, password: 'old_password')

     visit sign_in_path

     click_link "Forgot password?"
     fill_in "Email", :with => alice.email
     click_button 'Send Email'

     open_email(alice.email)
     current_email.click_link "Reset my password" 

     expect(page).to have_content "Reset Your Password"
     fill_in "Password", :with => 'new_password'
     click_button 'Reset password'

     expect(page).to have_content 'Sign in'
     fill_in "Email", :with => alice.email
     fill_in "Password", :with => 'new_password'
     click_button 'Sign In'

     expect(page).to have_content "Welcome, #{alice.full_name}"
  end
end