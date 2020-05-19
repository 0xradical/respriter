require_relative '../spec_helper'

describe PipelineTemplate, model: true do
  let :common_params do
    {
      data:                  { some_data: 'here' },
      pipes:                 Pipes::Mocked.random_pipes,
      dataset:               Dataset.create,
      bootstrap_script_type: :sql,
      bootstrap_script:      'SELECT 1+1;',
      success_script_type:   :sql,
      success_script:        'SELECT 1+2;',
      waiting_script_type:   :sql,
      waiting_script:        'SELECT 1+3;',
      fail_script_type:      :sql,
      fail_script:           'SELECT 1+4;'
    }
  end

  let :overdefined_params do
    {
      data:                  { new_data: 'right here' },
      pipes:                 Pipes::Mocked.random_pipes,
      dataset:               Dataset.create,
      bootstrap_script_type: :ruby,
      bootstrap_script:      'puts 1',
      success_script_type:   :ruby,
      success_script:        'puts 2',
      waiting_script_type:   :ruby,
      waiting_script:        'puts 3',
      fail_script_type:      :ruby,
      fail_script:           'puts 4'
    }
  end

  describe 'an empty pipeline creation' do
    subject{ PipelineTemplate.create common_params.merge(name: 'Nice Dataset') }

    let! :pipeline do
      Pipeline.create pipeline_template: subject
    end

    it 'should use template params' do
      pipeline.reload

      common_params.each do |key, value|
        expect( pipeline.send key ).to eq value
      end
    end
  end

  describe 'a full pipeline creation' do
    subject{ PipelineTemplate.create common_params.merge(name: 'Nice Dataset') }

    let! :pipeline do
      params = overdefined_params.merge pipeline_template: subject
      Pipeline.create params
    end

    it 'should use its provided params' do
      pipeline.reload

      overdefined_params.each do |key, value|
        expect( pipeline.send key ).to eq value
      end
    end
  end

end
