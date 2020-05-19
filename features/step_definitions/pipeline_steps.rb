Given /^a Dataset named as (.*)$/ do |name|
  @dataset = Dataset.find_or_create_by name: name
end

Given /^a (Pipes::\w+) (with|without) options$/ do |*args|
  processor_class, with_or_without, raw_options = args

  options = if with_or_without == 'with' # Then U2
    eval(raw_options).deep_symbolize_keys
  else
    Hash.new
  end

  @pipe = processor_class.constantize.new options
end

Given /^a PipeProcess( with attributes)?$/ do |*args|
  with_or_without, options = args

  params = if with_or_without.blank?
    { pipeline: @pipeline }
  else
    eval(options).deep_symbolize_keys
  end

  if params[:pipeline].blank? && params[:pipeline_id].blank?
    params[:pipeline] = @pipeline
  end

  @pipe_process = PipeProcess.create params
end

Given /^(a|\@[\w\_\d]+) PipelineExecution( with attributes)?$/ do |*args|
  variable_name, with_or_without, options = args

  params = {
    name:    Faker::Company.name,
    dataset: @dataset
  }

  unless with_or_without.blank?
    params = params.merge eval(options).deep_symbolize_keys
  end

  pipeline_execution = PipelineExecution.create params

  if variable_name == 'a'
    @pipeline_execution = pipeline_execution
  else
    instance_variable_set variable_name, pipeline_execution
  end
end

Given /^same (\@[\w\_\d]+) PipelineExecution$/ do |variable_name|
  @pipeline_execution = instance_variable_get variable_name
end

Given /^(a|\@[\w\d]+) Pipeline( with attributes)?$/ do |*args|
  variable_name, with_or_without, options = args

  pipes = @pipes || [@pipe].compact
  params = {
    pipeline_execution: (@pipeline_execution || PipelineExecution.create(name: 'execution')),
    pipeline_template:  @pipeline_template,
    name:               (@pipeline_template&.name || 'Some pipe'),
    dataset:            @dataset,
    pipes:              pipes
  }

  unless with_or_without.blank?
    params = params.merge eval(options).deep_symbolize_keys
  end

  pipeline = Pipeline.create params

  if variable_name == 'a'
    @pipeline = pipeline
  else
    instance_variable_set variable_name, pipeline
  end
end

When /^pipe_process is executed$/ do
  @pipe_process.call!
end

When /^pipe is executed$/ do
  begin
    @pipe.call @pipe_process
  rescue
    @pipe_execution_error = $!
  end
end

When /^pipe_process is reloaded$/ do
  @pipe_process.reload
end

When /^observing pipe execution$/ do
  @last_expectation = expect{ @pipe.call @pipe_process }
end

Then /^pipe execution raises an error$/ do
  expect(@pipe_execution_error).to be_present
end

Then /^pipe_process should be retried$/ do
  expect(@pipe_process).to be_should_retry
end

Then /^(.*) have (not )?changed$/ do |snippet, not_or_blank|
  if not_or_blank.blank?
    @last_expectation.to change{ eval snippet }
  else
    @last_expectation.not_to change{ eval snippet }
  end
end

Then /^pipe_process (\w+) has those keys:?([\s\w\d]+)$/ do |attribute, keys|
  result_keys   = @pipe_process.public_send(attribute).keys.sort
  expected_keys = (keys.split(/\s+/).compact - ['']).sort.map &:to_sym

  expect(result_keys).to eq expected_keys
end

Then /^pipe_process ([\/\s\d\w\-\@]+) become:? (.*)$/ do |attribute_keys, evaluable_data|
  attribute_keys = (attribute_keys.split(/\s*\/\s*/).compact - ['']).map &:to_sym
  data = attribute_keys[1..-1].inject @pipe_process.public_send(attribute_keys.first) do |acc, key|
    if acc.is_a?(Array)
      acc[key.to_s.to_i]
    else
      acc[key]
    end
  end

  expected_data = eval evaluable_data
  expect(data).to eq expected_data
end

Then /^pipe_process ([\/\s\d\w\-\@]+) should (not )?be present$/ do |attribute_keys, not_present|
  attribute_keys = (attribute_keys.split(/\s*\/\s*/).compact - ['']).map &:to_sym
  data = attribute_keys[1..-1].inject @pipe_process.public_send(attribute_keys.first) do |acc, key|
    if acc.is_a?(Array)
      acc[key.to_s.to_i]
    else
      acc[key]
    end
  end

  if not_present.blank?
    expect(data).to be_present
  else
    expect(data).to_not be_present
  end
end

Then /^pipeline has (\d+) pipe_process(es)?$/ do |pipe_process_count, _|
  expect(@pipeline.pipe_processes.count).to eq pipe_process_count.to_i
end

Then /^pipeline has a pipe_process with (.*)$/ do |snippet|
  expect( @pipeline.pipe_processes.where eval(snippet) ).to be_exists
end

Then /^exists a (\w+) with (.*) attributes$/ do |relation_name, snippet|
  expect( relation_name.constantize.where eval(snippet) ).to be_exists
end

Then /^there is a (\w+) with (.*)$/ do |relation_name, snippet|
  object = relation_name.constantize.find_by eval(snippet)
  instance_variable_set "@#{relation_name.underscore}", object
  expect( object ).not_to be_nil
end

Then /^there are (\d+) (\w+) with (.*)$/ do |expected_occurrences, relation_name, snippet|
  occurrences = relation_name.constantize.where( eval(snippet) ).count
  expect( occurrences ).to eq expected_occurrences.to_i
end

Then /^(@[\w\d]+) has ([\w\d]+) as (.*)$/ do |variable_name, attribute, snippet|
  object = instance_variable_get variable_name
  expect( object.public_send attribute ).to eq eval(snippet)
end
