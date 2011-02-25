# coding: UTF-8

Given /^I have genres? called (.+)$/ do |genres|
  genres.split(", ").each do |genre|
    Factory(:genre, { :name => genre })
  end
end

Given /^I have no genres$/ do
  Genre.delete_all
end

When /^I add the genre (.+)$/ do |genre|
  visit new_genre_path
  fill_in "Genre", :with => genre
  click_button "Lagre"
end

Then /^I have ([0-9]+) genres?$/ do |count|
  Genre.all.size.should == count.to_i
end

And /^the genre name is (.+)$/ do |genre|
  Genre.first.name.should == genre
end

When /^I visit the new genre page$/ do
  visit new_genre_path
end

When /^I edit the genre name to (.+)$/ do |new_genre|
  visit edit_genre_path(Genre.first)
  fill_in "Genre", :with => new_genre
  click_button "Lagre"
end

When /^I visit the edit genre page$/ do
  visit edit_genre_path(Genre.first)
end
