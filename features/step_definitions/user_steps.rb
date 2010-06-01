Given /^the following role records$/ do |table|
  table.hashes.each do |hash|
    Factory(:role, hash)
  end
end


Given /^the following user records$/ do |table|
  table.hashes.each do |hash|
    role = hash['role']
    hash.delete 'role'

    user = Factory(:user, hash)
    user.roles << Role.find_by_name(role)

    user.save
  end
end


And /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  unless username == "guest"
    visit login_url
    fill_in "Brukernavn", :with => username
    fill_in "Passord", :with => password
    click_button "Logg på"
  end
end
