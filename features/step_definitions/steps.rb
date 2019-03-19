Given(/^I visit the sign up page$/) do
  visit new_user_account_registration_path
end

When(/^I fill my email "([^"]*)" and my password "([^"]*)"$/) do |email, password|
  fill_in "user_account[email]",                  with: email
  fill_in "user_account[password]",               with: password
  fill_in "user_account[password_confirmation]",  with: password
end

When(/^I click on "([^"]*)"$/) do |arg1|
  click_on arg1
end

When(/^I click on the course button$/) do
  @gateway_window = window_opened_by { find(:xpath, "//a[@href='/forward/#{@course.id}'][@target='_blank']").click }
end

Then(/^an user account with email "([^"]*)" is created$/) do |email|
  account = UserAccount.find_by(email: email)
  expect(account).to be_present
end

Then(/an user account with email "([^"]*)" is not created/) do |email|
  expect { UserAccount.find_by!(email: email)}.to raise_error(ActiveRecord::RecordNotFound)
end

Then(/^an user account with email "([^"]*)" is created and associated with "([^"]*)"$/) do |email, provider|
  user = UserAccount.find_by(email: email)
  expect(user.oauth_accounts.find_by(provider: provider)).to be_present
end

Then(/^I can see my dashboard$/) do
end

Then(/^I should receive an$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I connect with my "([^"]*)" account$/) do |arg1|
  click_on arg1
end

When(/^my email is missing$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Given("I'm on a search result page") do
  @course = create(:course)
  Course.default_import_to_search_index
  visit courses_path
end

Then("I'm forwarded to the course provider") do
  pending
  # within_window @gateway_window do
    # expect(Enrollment.find_by(course_id: @course.id)).to exist
  # end
end
