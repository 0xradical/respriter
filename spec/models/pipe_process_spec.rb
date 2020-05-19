require_relative '../spec_helper'

describe PipeProcess, model: true do
  describe 'with empty pipeline pipes' do
    subject do
      PipeProcess.create pipeline: Pipeline.new(pipes: [], name: Faker::Lorem.word)
    end

    it 'should not be called' do
      expect{ subject.call! }.to raise_error('missing pipes')
    end
  end

  describe 'when an Error is raised' do
    subject do
      pipes = Pipes::Mocked.pipes(
        { accumulator: previous_accumulator },
        {
          eval: %{
            pipe_process.accumulator = #{accumulator.inspect}
            pipe_process.data        = #{data.inspect}
            raise #{error_message.inspect}
          }
        },
        { status: :succeeded }
      )
      PipeProcess.create pipeline: Pipeline.create( pipes: pipes, name: Faker::Lorem.word )
    end

    let :previous_accumulator do
      { initial: true }
    end

    let :accumulator do
      { edited_accumulator: true }
    end

    let :data do
      { edited_data: true }
    end

    let :error_message do
      'something went wrong here...'
    end

    it 'should change status to failed and keep previous accumulator and data' do
      expect{ subject.call! }.to_not raise_error

      expect( subject.data                  ).to be_nil
      expect( subject.status                ).to eq :failed
      expect( subject.accumulator           ).to eq previous_accumulator
      expect( subject.error_backtrace.first ).to eq error_message
      expect( subject.process_index         ).to eq 1
    end
  end

  describe 'retring a pipe' do
    subject do
      @error_message = 'Just retried!'

      first_pipe = {
        script: {
          type:        :ruby,
          source_code: %{
            if retried?
              pipe_process.data = { retried: true }
            else
              pipe_process.data = { retried: false }
            end
          }
        }
      }

      retry_pipe = {
        script: {
          type:        :ruby,
          source_code: %{
            retry!('#{@error_message}') unless retried?
          }
        }
      }

      @pipeline = Pipeline.new(
        name:  Faker::Lorem.word,
        pipes: Pipes::Mocked.pipes(first_pipe, retry_pipe, Hash.new)
      )
      PipeProcess.create pipeline: @pipeline
    end

    it 'should schedule a retry and stay as pending when it stopped' do
      expect(subject).to receive(:save!).and_call_original.twice
      expect{ subject.call! }.to_not raise_error

      expect(subject).to be_should_retry
      expect(subject).to be_retried

      expect(subject.status).to             eq :pending
      expect(subject.process_index).to      eq 1
      expect(subject.error_backtrace[0]).to eq @error_message
      expect(subject.data[:retried]).to     be_falsey

      subject.reload
      last_updated_at = subject.updated_at
      Pipeline.any_instance.stub(:notify!).and_return true
      run_background_jobs at: 7.minutes.from_now, remove: true

      subject.reload
      expect(subject.status).to             eq :pending
      expect(subject.process_index).to      eq 1
      expect(subject.error_backtrace[0]).to eq @error_message
      expect(subject.updated_at).to         eq last_updated_at

      run_background_jobs at: 8.minutes.from_now, remove: true
      subject.reload

      expect(subject.status).to          eq :succeeded
      expect(subject.total_retries).to   eq 1
      expect(subject.process_index).to   eq 2
      expect(subject.error_backtrace).to be_blank
      expect(subject.data[:retried]).to  be_truthy
      expect(subject.updated_at).to_not  eq last_updated_at
    end
  end

  describe 'retring a pipe to exaustion' do
    subject do
      @error_message = 'Just retried!'

      retry_pipe = {
        script: {
          type:        :ruby,
          source_code: "retry! '#{@error_message}'"
        }
      }

      @max_retries = rand 2..5
      @pipeline = Pipeline.new(
        name:        Faker::Lorem.word,
        pipes:       Pipes::Mocked.pipes(Hash.new, retry_pipe, Hash.new),
        max_retries: @max_retries
      )
      PipeProcess.create pipeline: @pipeline
    end

    it 'should schedule retries until it reaches it max_retries' do
      expect(subject).to receive(:save!).and_call_original.twice
      expect{ subject.call! }.to_not raise_error

      expect(subject).to be_should_retry
      expect(subject).to be_retried

      expect(subject.status).to             eq :pending
      expect(subject.process_index).to      eq 1
      expect(subject.error_backtrace[0]).to eq @error_message

      subject.reload
      last_updated_at = subject.updated_at
      Pipeline.any_instance.stub(:notify!).and_return true

      intervals = [8, 16, 32, 64, 128]
      (@max_retries - 1).times do |n|
        subject.reload
        expect(subject.status).to             eq :pending
        expect(subject.process_index).to      eq 1
        expect(subject.error_backtrace[0]).to eq @error_message
        last_updated_at = subject.updated_at

        run_background_jobs at: (intervals[n]-1).minutes.from_now, remove: true

        subject.reload
        expect(subject.updated_at).to eq last_updated_at

        run_background_jobs at: intervals[n].minutes.from_now, remove: true
      end

      subject.reload
      expect(subject.status).to             eq :failed
      expect(subject.total_retries).to      eq @max_retries
      expect(subject.process_index).to      eq 1
      expect(subject.error_backtrace[0]).to eq 'Exceeded retry attempts'
    end
  end

  PipeProcess::STATUSES.each do |status|
    describe "with single pipeline pipe that changes status to #{status}" do
      subject do
        PipeProcess.create(
          pipeline: Pipeline.new(
            name: Faker::Lorem.word,
            pipes: Pipes::Mocked.pipes(status: status)
          )
        )
      end

      it 'should change status when called' do
        expect(subject).to receive(:save!).and_call_original.once
        expect{ subject.call! }.to_not raise_error

        if status == :pending
          expect(subject.status).to eq :succeeded
        else
          expect(subject.status).to eq status
        end
        expect(subject.process_index).to eq 0
      end
    end

    describe "when Pipe::Error is raised with status as #{status}" do
      subject do
        pipes = Pipes::Mocked.pipes(
          { accumulator: previous_accumulator },
          {
            eval: %{
              pipe_process.accumulator = #{accumulator.inspect}
              pipe_process.data        = #{data.inspect}
              raise Pipe::Error.new(#{status.inspect}, #{error_message.inspect})
            }
          },
          { status: :succeeded }
        )
        PipeProcess.create pipeline: Pipeline.create( pipes: pipes, name: Faker::Lorem.word )
      end

      let :previous_accumulator do
        { initial: true }
      end

      let :accumulator do
        { edited_accumulator: true }
      end

      let :data do
        { edited_data: true }
      end

      let :error_message do
        "raised status by error #{status}"
      end

      it 'should change status when called and keep previous accumulator and data' do
        expect{ subject.call! }.to_not raise_error

        expect( subject.data                  ).to be_nil
        expect( subject.status                ).to eq status
        expect( subject.accumulator           ).to eq previous_accumulator
        expect( subject.error_backtrace.first ).to eq error_message
        expect( subject.process_index         ).to eq 1
      end
    end

    describe "with pipeline pipe that ends with status to #{status}" do
      subject do
        pipes_params = Array.new rand(1..10), nil
        pipes_params << { status: status }
        PipeProcess.create(
          pipeline: Pipeline.new(
            name:  Faker::Lorem.word,
            pipes: Pipes::Mocked.pipes(*pipes_params)
          )
        )
      end

      it 'should change status when called' do
        number_of_pipes = subject.pipeline.pipes.size

        expect(subject).to receive(:save!).and_call_original.exactly(number_of_pipes).times
        expect{ subject.call! }.to_not raise_error

        if status == :pending
          expect(subject.status).to eq :succeeded
        else
          expect(subject.status).to eq status
        end

        expect(subject.process_index).to eq(number_of_pipes-1)
      end
    end

    describe "with pipeline pipe that starts with status to #{status}" do
      subject do
        pipes_params = Array.new rand(1..10), nil
        pipes_params.unshift status: status
        PipeProcess.create pipeline: Pipeline.new( name: Faker::Lorem.word, pipes: Pipes::Mocked.pipes(*pipes_params) )
      end

      if status == :pending
        it 'should change status when called' do
          number_of_pipes = subject.pipeline.pipes.size
          expect(subject).to receive(:save!).and_call_original.exactly(number_of_pipes).times
          expect{ subject.call! }.to_not raise_error
          expect(subject.status).to eq :succeeded
          expect(subject.process_index).to eq(number_of_pipes-1)
        end
      else
        it 'should change status when called' do
          expect(subject).to receive(:save!).and_call_original.once
          expect{ subject.call! }.to_not raise_error
          expect(subject.status).to eq status
          expect(subject.process_index).to eq 0
        end
      end
    end

    if status != :pending
      describe "try calling again a terminated pipe processor" do
        subject do
          pipes_params = Array.new rand(1..10), nil
          pipes_params << { status: status }
          PipeProcess.create process_index: (pipes_params.size-1), status: status, pipeline: Pipeline.new( name: Faker::Lorem.word, pipes: Pipes::Mocked.pipes(*pipes_params) )
        end

        it 'should not do nothing' do
          number_of_pipes = subject.pipeline.pipes.size

          expect(subject).to_not                receive(:save!).and_call_original
          expect(subject.pipeline.pipes).to_not receive(:call).and_call_original
          expect(subject.process_index).to      eq(number_of_pipes-1)
          expect(subject.status).to             eq(status)

          subject.call!
        end
      end
    end
  end
end
