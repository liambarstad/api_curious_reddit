require 'rails_helper'

RSpec.feature "user can authenticate" do
  scenario "from main page" do
    visit root_path
    click_on "Login"
    within("#login-panel") do
      fill_in "user", with: KeyHandler.test_username
      fill_in "passwd", with: KeyHandler.test_password
      click_on "log in"
    end

    expect(current_path).to eq('/dashboard')
    expect(page).to have_content('Logout')
    expect(page).to_not have_content('Login')
  end
end
