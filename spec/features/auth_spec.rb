require 'spec_helper'
require 'rails_helper'

feature 'the signup process' do
  before :each do
    visit new_user_url
  end

  scenario 'has a new user page' do
    expect(page).to have_content 'Sign Up'
  end

  scenario 'has new user form' do
    expect(page).to have_content 'Username'
    expect(page).to have_content 'Password'
  end

  feature 'signing up a user' do
    scenario 'shows username on the homepage after signup' do
      visit new_user_url
      fill_in 'Username', with: 'Apple'
      fill_in 'Password', with: 'password'
      click_button 'Sign Up'
      expect(page).to have_content 'Apple'
    end
  end
end

feature 'logging in' do
  scenario 'shows username on the homepage after login' do
    User.create(username: 'Apple', password: 'password')
    visit new_session_url
    fill_in 'Username', with: 'Apple'
    fill_in 'Password', with: 'password'
    click_button 'Sign In'
    expect(page).to have_content 'Apple'
    expect(page).to have_button 'Sign Out'
  end
end

feature 'logging out' do
  scenario 'begins with a logged out state' do
    visit '/'
    expect(page).not_to have_button 'Sign Out'
  end

  scenario 'doesn\'t show username on the homepage after logout' do
    visit new_user_url
    fill_in 'Username', with: 'Apple'
    fill_in 'Password', with: 'password'
    click_button 'Sign Up'
    click_button 'Sign Out'
    expect(page).not_to have_content 'Apple'
  end

end
