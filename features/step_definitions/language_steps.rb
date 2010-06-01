Given /^I have languages? called (.+)$/ do |languages|
  languages.split(", ").each do |language|
    Factory(:language, {:name => language})
  end
end

Given /^I have no languages$/ do
  Language.delete_all
end

When /^I add the language (.+)$/ do |language|
  visit new_language_path
  fill_in "Språk", :with => language
  click_button "Lagre"
end

Then /^I have ([0-9]+) languages?$/ do |count|
  Language.all.size.should == count.to_i
end

And /^the language name is (.+)$/ do |language|
  Language.first.name.should == language
end

When /^I visit the new language page$/ do
  visit new_language_path
end

When /^I edit the language name to (.+)$/ do |new_language|
  visit edit_language_path(Language.first)
  fill_in "Språk", :with => new_language
  click_button "Lagre"
end

When /^I visit the edit language page$/ do
  visit edit_language_path(Language.first)
end
