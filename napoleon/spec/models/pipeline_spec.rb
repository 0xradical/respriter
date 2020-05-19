require_relative '../spec_helper'

describe Pipeline, model: true do
  before do
    Mail::TestMailer.deliveries.clear
    Que.clear!
  end

  after do
    Mail::TestMailer.deliveries.clear
    Que.clear!
  end

  [:succeeded, :waiting, :failed].each do |status|
    describe "notificating" do
      subject do
        name = "#{Faker::Company.bs } ##{rand 1000}"
        pipeline_template = PipelineTemplate.create(
          name:                  name,
          pipes:                 Pipes::Mocked.pipes(status: status),
          bootstrap_script_type: :sql,
          bootstrap_script:      "INSERT INTO app.pipe_processes (pipeline_id) VALUES ($1.id); SELECT app.pipeline_call($1.id);"
        )
        PipelineExecution.create run_at: Time.now, name: name, pipeline_template: pipeline_template, schedule_interval: '1 week'
      end

      it "should be notified when pipeline change its status to #{status}" do
        stub_request(
          :post,
          ENV['SLACK_NOTIFICATION_WEBHOOK']
        ).with(
          body: /#{status}/
        ).to_return(status: 200)

        subject.reload
        run_background_jobs job_class: 'PipelineExecution::CallJob', remove: true
        run_background_jobs job_class: 'PipeProcess::CallJob',       remove: true
        run_background_jobs job_class: 'Pipeline::NotifyJob',        remove: true
        run_background_jobs remove: true

        expect(
          a_request(:post, ENV['SLACK_NOTIFICATION_WEBHOOK'])
        ).to have_been_made.once
      end
    end
  end

  describe 'with recurrent scheduling' do
    let :pipeline_template do
      PipelineTemplate.create(
        name:                  "#{Faker::Company.bs } ##{rand 1000}",
        pipes:                 Pipes::Mocked.pipes(status: :succeeded),
        bootstrap_script_type: :sql,
        bootstrap_script:      "INSERT INTO app.pipe_processes (pipeline_id) VALUES ($1.id); SELECT app.pipeline_call($1.id);"
      )
    end

    subject do
      PipelineExecution.create(
        run_at:            Time.now,
        name:              "#{Faker::Company.bs } ##{rand 1000}",
        pipeline_template: pipeline_template,
        schedule_interval: '1 week'
      )
    end

    it "should be created another pipeline for next week" do
      stub_request(
        :post,
        ENV['SLACK_NOTIFICATION_WEBHOOK']
      ).with(
        body: /succeeded/
      ).to_return(status: 200)

      subject.reload
      run_background_jobs job_class: 'PipelineExecution::CallJob', remove: true
      run_background_jobs job_class: 'PipeProcess::CallJob',       remove: true
      run_background_jobs job_class: 'Pipeline::NotifyJob',        remove: true
      run_background_jobs remove: true

      expect(
        a_request(:post, ENV['SLACK_NOTIFICATION_WEBHOOK'])
      ).to have_been_made.once

      expect do
        subject.update status: :succeeded
        run_background_jobs at: 1.week.from_now, remove: true
      end.to change{ Pipeline.count }.by(1)

      next_pipeline = Pipeline.where(pipeline_template_id: pipeline_template.id).order(:created_at).last
      expect(next_pipeline.status).to                     eq :pending
      expect(next_pipeline.pipeline_execution.counter).to be(2)
    end
  end

  describe 'with custom scripts' do
    let :default_params do
      {
        name:                  "#{Faker::Company.bs} ##{rand 1000}",
        bootstrap_script_type: :sql,
        bootstrap_script:      'UPDATE pipelines SET data = jsonb_set(COALESCE(data, \'{}\'), \'{bootstrap}\', (\'{"invoked": true, "count": \' || subquery.count || \'}\')::jsonb) FROM (SELECT COUNT(*) AS count FROM pipe_processes WHERE pipeline_id = $1.id) AS subquery WHERE id = $1.id;',
        success_script_type:   :sql,
        success_script:        'UPDATE pipelines SET data = jsonb_set(COALESCE(data, \'{}\'), \'{succeeded}\', \'true\'::jsonb) WHERE id = $1.id;',
        waiting_script_type:   :sql,
        waiting_script:        'UPDATE pipelines SET data = jsonb_set(COALESCE(data, \'{}\'), \'{waiting}\', \'true\'::jsonb) WHERE id = $1.id;',
        fail_script_type:      :sql,
        fail_script:           'UPDATE pipelines SET data = jsonb_set(COALESCE(data, \'{}\'), \'{failed}\', \'true\'::jsonb) WHERE id = $1.id;'
      }
    end

    describe 'a simple pipeline' do
      subject do
        params = default_params.merge pipes: Pipes::Mocked.pipes(status: :pending)
        Pipeline.create params
      end

      it 'should have no processors' do
        subject.reload

        expect( subject.data[:bootstrap][:invoked] ).to be true
        expect( subject.data[:bootstrap][:count]   ).to be 0

        [ :waiting, :failed, :succeeded ].each do |counter_status|
          expect( subject.data[:counter_status] ).to be_nil
        end

        expect( subject.total_count     ).to be 0
        expect( subject.succeeded_count ).to be 0
        expect( subject.waiting_count   ).to be 0
        expect( subject.failed_count    ).to be 0
      end
    end

    describe 'with some pipe processors' do
      subject do
        params = default_params.merge pipes: Pipes::Mocked.pipes(status: :pending)
        Pipeline.create params
      end

      let! :pipe_processes do
        3.times.map do
          PipeProcess.create pipeline_id: subject.id
        end
      end

      it 'should have have changed its total_count' do
        subject.reload

        expect( subject.data[:bootstrap][:invoked] ).to be true
        expect( subject.data[:bootstrap][:count]   ).to be 0

        [ :waiting, :failed, :succeeded ].each do |counter_status|
          expect( subject.data[:counter_status] ).to be_nil
        end

        expect( subject.total_count     ).to eq pipe_processes.count
        expect( subject.succeeded_count ).to be 0
        expect( subject.waiting_count   ).to be 0
        expect( subject.failed_count    ).to be 0
      end
    end

    [ :waiting, :failed, :succeeded ].each do |status|
      describe "with some #{status} pipe processors" do
        subject do
          params = default_params.merge pipes: Pipes::Mocked.pipes(status: :pending)
          Pipeline.create params
        end

        let! :pipe_processes do
          3.times.map do
            PipeProcess.create pipeline_id: subject.id
          end.map do |pipe_process|
            pipe_process.update status: status
            pipe_process
          end
        end

        it 'should have have changed its total_count' do
          subject.reload

          [ :waiting, :failed, :succeeded ].each do |counter_status|
            if counter_status == status
              expect( subject.send(:"#{counter_status}_count") ).to eq pipe_processes.count
              expect( subject.data[counter_status]             ).to be true
            else
              expect( subject.send(:"#{counter_status}_count") ).to be 0
              expect( subject.data[counter_status]             ).to be_nil
            end
          end

          expect( subject.total_count ).to eq pipe_processes.count

          expect( subject.data[:bootstrap][:invoked] ).to be true
          expect( subject.data[:bootstrap][:count]   ).to be 0
        end
      end
    end

    describe "with some skipped pipe processors" do
      subject do
        params = default_params.merge pipes: Pipes::Mocked.pipes(status: :pending)
        Pipeline.create params
      end

      let! :pipe_processes do
        3.times.map do
          PipeProcess.create pipeline_id: subject.id
        end.map do |pipe_process|
          pipe_process.update status: :skipped
          pipe_process
        end
      end

      it 'should have have changed its total_count' do
        subject.reload

        expect( subject.data[:bootstrap][:invoked] ).to be true
        expect( subject.data[:bootstrap][:count]   ).to be 0

        expect( subject.data[:succeeded] ).to eq true
        expect( subject.data[:waiting]   ).to be_nil
        expect( subject.data[:failed]    ).to be_nil

        expect( subject.total_count     ).to eq pipe_processes.count
        expect( subject.succeeded_count ).to eq pipe_processes.count
        expect( subject.waiting_count   ).to be 0
        expect( subject.failed_count    ).to be 0
      end
    end

    describe "with each kind of terminating status" do
      subject do
        params = default_params.merge pipes: Pipes::Mocked.pipes(status: :pending)
        Pipeline.create params
      end

      let! :pipe_processes do
        [ :skipped, :waiting, :failed, :succeeded ].map do |status|
          [
            PipeProcess.create(pipeline_id: subject.id),
            status
          ]
        end.map do |pipe_process, status|
          pipe_process.update status: status
          pipe_process
        end
      end

      it 'should have have changed its total_count' do
        subject.reload

        expect( subject.data[:bootstrap][:invoked] ).to be true
        expect( subject.data[:bootstrap][:count]   ).to be 0

        expect( subject.data[:succeeded] ).to be_nil
        expect( subject.data[:waiting]   ).to be_nil
        expect( subject.data[:failed]    ).to be true

        expect( subject.total_count     ).to eq pipe_processes.count
        expect( subject.succeeded_count ).to eq 2
        expect( subject.waiting_count   ).to be 1
        expect( subject.failed_count    ).to be 1
      end
    end

    describe "with each kind of terminating status, except waiting" do
      subject do
        params = default_params.merge pipes: Pipes::Mocked.pipes(status: :pending)
        Pipeline.create params
      end

      let! :pipe_processes do
        [ :skipped, :failed, :succeeded ].map do |status|
          [
            PipeProcess.create(pipeline_id: subject.id),
            status
          ]
        end.map do |pipe_process, status|
          pipe_process.update status: status
          pipe_process
        end
      end

      it 'should have have changed its total_count' do
        subject.reload

        expect( subject.data[:bootstrap][:invoked] ).to be true
        expect( subject.data[:bootstrap][:count]   ).to be 0

        expect( subject.data[:succeeded] ).to be_nil
        expect( subject.data[:waiting]   ).to be_nil
        expect( subject.data[:failed]    ).to be true

        expect( subject.total_count     ).to eq pipe_processes.count
        expect( subject.succeeded_count ).to eq 2
        expect( subject.waiting_count   ).to be 0
        expect( subject.failed_count    ).to be 1
      end
    end

    describe "with each kind of status, except waiting" do
      subject do
        params = default_params.merge pipes: Pipes::Mocked.pipes(status: :pending)
        Pipeline.create params
      end

      let! :pipe_processes do
        [ :pending, :skipped, :failed, :succeeded ].map do |status|
          [
            PipeProcess.create(pipeline_id: subject.id),
            status
          ]
        end.map do |pipe_process, status|
          pipe_process.update status: status
          pipe_process
        end
      end

      it 'should have have changed its total_count' do
        subject.reload

        expect( subject.data[:bootstrap][:invoked] ).to be true
        expect( subject.data[:bootstrap][:count]   ).to be 0

        expect( subject.data[:succeeded] ).to be_nil
        expect( subject.data[:waiting]   ).to be_nil
        expect( subject.data[:failed]    ).to be_nil

        expect( subject.total_count     ).to eq pipe_processes.count
        expect( subject.succeeded_count ).to eq 2
        expect( subject.waiting_count   ).to be 0
        expect( subject.failed_count    ).to be 1
      end
    end
  end
end
