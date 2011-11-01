Then /^I should see "([^"]*)"$/ do |text|
  response_body.should =~ Regexp.new(Regexp.escape(text))
end


Then /^the title should contain "([^"]*)"$/ do |text|
  response_body.should =~ Regexp.new("<title>#{text}</title>")
end
