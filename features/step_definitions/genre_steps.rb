Given /^I have genres called (.+)$/ do |genres|
  genres.split(", ").each do |genre|
    Factory(:genre, { :name => genre })
  end
end
