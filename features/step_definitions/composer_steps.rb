# coding: UTF-8

Given /^I have composers called (.+)$/ do |composers|
  composers.split(", ").each do |composer|
    Factory(:composer, { :name => composer })
  end
end
