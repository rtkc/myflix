require 'spec_helper'

feature 'User registers', { js: true, vcr: true } do 
  background { visit register_path }

  scenario "with valid user info and card" do 
    fill_in_valid_user_info
    fill_in_card_info("4242424242424242")
    click_button "Sign Up" 
    expect(page).to have_content ("You have signed up successfully.")
  end

  scenario "with valid user info and invalid card" do 
    fill_in_valid_user_info
    fill_in_card_info("345")
    click_button "Sign Up" 
    expect(page).to have_content ("The card number is not a valid credit card number.")
  end

  scenario "with valid user info and declined card" do 
    fill_in_valid_user_info
    fill_in_card_info("400000000000002")
    click_button "Sign Up" 
    expect(page).to have_content ("Your card number is incorrect.")
  end

  scenario "with invalid user info and valid card" do 
    fill_in_invalid_user_info
    fill_in_card_info("4242424242424242")
    click_button "Sign Up" 
    expect(page).to have_content ("The user information you entered is incorrect. Please try again.")
  end

  scenario "with invalid user info and invalid card" do 
    fill_in_invalid_user_info
    fill_in_card_info("345")
    click_button "Sign Up" 
    expect(page).to have_content ("The card number is not a valid credit card number.")
  end

  scenario "with invalid user info and declined card" do 
    fill_in_invalid_user_info
    fill_in_card_info("400000000000002")
    click_button "Sign Up" 
    expect(page).to have_content ("Your card number is incorrect.")
  end

  def fill_in_valid_user_info 
    fill_in "Full Name", with: "Jim Tealeaf"
    fill_in "Email Address", with: "jim@tealeaf.com"
    fill_in "Password", with: "password"
  end

  def fill_in_invalid_user_info
    fill_in "Email Address", with: "jim@tealeaf.com"
  end

  def fill_in_card_info(card_number)
    fill_in "Credit Card Number", with: card_number
    fill_in "Security Code", with: "123"
    select "12 - December",from: "date_month"
    select "2018", from: "date_year"
  end
end