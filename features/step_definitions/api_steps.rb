Given(/^not authenticated operator$/) do
end

Given(/^authenticated operator as (.+)$/) do |operator_type|
  @current_operator = create operator_type.to_sym
  instance_variable_set :"@current_#{operator_type}", @current_operator
  authenticate @current_operator
end

When(/^(?:|I )get (.+) endpoint$/) do |endpoint_name|
  get path_to(endpoint_name)
end

When(/^(?:|I )post on (.+) endpoint$/) do |endpoint_name, params|
  post_json path_to(endpoint_name), YAML.parse(params).deep_symbolize_keys
end

When(/^(?:|I )patch on (.+) endpoint$/) do |endpoint_name, params|
  patch_json path_to(endpoint_name), YAML.parse(params).deep_symbolize_keys
end

Then(/^(?:|I )should get (.+) status code$/) do |status_name|
  expect(last_response).to send("be_#{status_name.gsub(/\s+/, '_')}")
end

Then(/^store ([\w_\[\]]+) as (\@[\w_]+)$/) do |value, name|
  data = value.split(/[\[\]]+/).inject(last_json_response) do |acc, val|
    if acc.is_a?(Array)
      acc[val.to_i]
    else
      acc[val]
    end
  end
  instance_variable_set name, data
end

Then(/^last response contains value ([\w_]+) matching stored \@([\w_]+)$/) do |value, name|
  stored_value = instance_variable_get "@#{name}"
  expect(last_json_response.map{ |res| res[value] }).to include(stored_value)
end
