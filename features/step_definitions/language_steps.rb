Given /^I have languages called (.+)$/ do |languages|
  languages.split(", ").each do |language|
    Factory(:language, { :name => language })
  end
end
