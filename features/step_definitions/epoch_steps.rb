Given /^I have epochs called (.+)$/ do |epochs|
  epochs.split(", ").each do |epoch|
    Factory(:period, { :name => epoch })
  end
end
