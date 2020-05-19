require_relative '../spec_helper'

describe Pipe do
  describe 'when raised Pipe::Error on execution' do
    PipeProcess::STATUSES.each do |status|
      describe "with status #{status}" do
        subject do
          Pipes::Mocked.new(raise: Pipe::Error.new(status, error_message))
        end

        let :error_message do
          "raised status by error #{status}"
        end

        let :pipe_process do
          double :pipe_process, accumulator: { key: 'value' }
        end

        it 'should persist status errors accordingly' do
          expect(pipe_process).to_not receive(:data=)
          expect(pipe_process).to_not receive(:status=)
          expect(pipe_process).to_not receive(:accumulator=)
          expect(pipe_process).to_not receive(:process_index=)
          expect(pipe_process).to_not receive(:error_backtrace=)

          expect{ subject.call pipe_process }.to raise_error(Pipe::Error)
        end
      end
    end
  end

  describe 'when terminator status returned on execution' do
    PipeProcess::STATUSES.each do |status|
      describe "with status #{status}" do
        subject do
          Pipes::Mocked.new(status: status)
        end

        let :pipe_process do
          double :pipe_process, accumulator: { key: 'value' }
        end

        it 'should persist status errors accordingly' do
          expect(pipe_process).to     receive(:status=).with(status).once
          expect(pipe_process).to     receive(:accumulator=).once
          expect(pipe_process).to_not receive(:data=)
          expect(pipe_process).to_not receive(:error_backtrace=)
          expect(pipe_process).to_not receive(:process_index=)

          expect{ subject.call pipe_process }.to_not raise_error
        end
      end
    end
  end

  describe 'when Ruby modifier_script is present' do
    describe "when an error is raised by script" do
      subject do
        Pipes::Mocked.new(script: { type: :ruby, source_code: "raise #{error_message}" })
      end

      let :error_message do
        'something went wrong here'
      end

      let :pipe_process do
        double(
          :pipe_process,
          id:            SecureRandom.uuid,
          accumulator:   { key: 'value' },
          process_index: 0
        )
      end

      it 'should raise Pipe::Error to outside' do
        expect(pipe_process).to receive(:status=).with(:pending).once

        begin
          subject.call pipe_process
          expect(false).to be_truthy, 'should have raised an error'
        rescue
          expect($!.class).to  eq Pipe::Error
          expect($!.status).to eq :failed
        end
      end
    end

    PipeProcess::STATUSES.each do |status|
      describe "when Pipe::Error is raised by script with status as #{status}" do
        subject do
          source_code = "raise Pipe::Error.new(#{status.inspect}, #{error_message.inspect})"
          Pipes::Mocked.new(script: { type: :ruby, source_code: source_code })
        end

        let :error_message do
          "raised status by error #{status}"
        end

        let :pipe_process do
          double(
            :pipe_process,
            id:            SecureRandom.uuid,
            accumulator:   { key: 'value' },
            process_index: 0
          )
        end

        it 'should raise Pipe::Error to outside' do
          expect(pipe_process).to receive(:status=).with(:pending).once

          begin
            subject.call pipe_process
            expect(false).to be_truthy, 'should have raised an error'
          rescue
            expect($!.class).to  eq Pipe::Error
            expect($!.status).to eq status
          end
        end
      end

      describe "and call or execute is never invoked with pipe status as #{status} but pipe_process is edited" do
        subject do
          source_code = %{
            pipe_process.data        = #{data.inspect}
            pipe_process.status      = #{status.inspect}
            pipe_process.accumulator = #{accumulator.inspect}
            pipe_process.non_existent_method
          }
          Pipes::Mocked.new(status: status, script: { type: :ruby, source_code: source_code })
        end

        let :data do
          { data: true }
        end

        let :accumulator do
          { accumulator: true }
        end

        let :pipe_process do
          double(
            :pipe_process,
            id:            SecureRandom.uuid,
            accumulator:   { key: 'value' },
            process_index: 0
          )
        end

        it 'should persist pipe_process data accordingly' do
          expect(subject).to_not      receive(:execute)

          expect(pipe_process).to     receive(:non_existent_method).once
          expect(pipe_process).to     receive(:data=).with(data).once
          expect(pipe_process).to     receive(:accumulator=).with(accumulator).once
          expect(pipe_process).to_not receive(:error_backtrace=)
          expect(pipe_process).to_not receive(:process_index=)

          first_status_editing = true
          expect(pipe_process).to receive(:status=) do |received_status|
            if first_status_editing
              expect(received_status).to eq(:pending)
              first_status_editing = false
            else
              expect(received_status).to eq(status)
            end
          end.twice

          expect{ subject.call pipe_process }.to_not raise_error
        end
      end

      describe "noop ruby script over pipe with status as #{status}" do
        subject do
          Pipes::Mocked.new(status: status, script: { type: :ruby, source_code: 'pipe_process.non_existent_method' })
        end

        let :pipe_process do
          double(
            :pipe_process,
            id:            SecureRandom.uuid,
            accumulator:   { key: 'value' },
            process_index: 0
          )
        end

        it 'should only invoke a noop method' do
          expect(subject).to_not      receive(:execute)

          expect(pipe_process).to     receive(:non_existent_method).once
          expect(pipe_process).to     receive(:status=).with(:pending).once
          expect(pipe_process).to_not receive(:data=)
          expect(pipe_process).to_not receive(:script=)
          expect(pipe_process).to_not receive(:accumulator=)
          expect(pipe_process).to_not receive(:error_backtrace=)
          expect(pipe_process).to_not receive(:process_index=)

          expect{ subject.call pipe_process }.to_not raise_error
        end
      end

      describe "execute is invoked but not changed anything related to pipe when status is #{status}" do
        subject do
          source_code = %{
            execute nothing_really_happens: true
            pipe_process.non_existent_method
          }
          Pipes::Mocked.new(status: status, script: { type: :ruby, source_code: source_code })
        end

        let :pipe_process do
          double(
            :pipe_process,
            id:            SecureRandom.uuid,
            accumulator:   { key: 'value' },
            process_index: 0
          )
        end

        it 'should not persist anything' do
          expect(pipe_process).to     receive(:status=).with(:pending).once
          expect(pipe_process).to     receive(:non_existent_method).once
          expect(pipe_process).to_not receive(:accumulator=)
          expect(pipe_process).to_not receive(:data=)
          expect(pipe_process).to_not receive(:error_backtrace=)
          expect(pipe_process).to_not receive(:process_index=)

          expect{ subject.call pipe_process }.to_not raise_error
        end
      end

      describe "call is invoked and edits pipe_process with status #{status}" do
        subject do
          source_code = %{
            call
            pipe_process.non_existent_method
          }
          Pipes::Mocked.new(status: status, script: { type: :ruby, source_code: source_code })
        end

        let :pipe_process do
          double(
            :pipe_process,
            id:            SecureRandom.uuid,
            accumulator:   { key: 'value' },
            process_index: 0
          )
        end

        it 'should evaluate call editing pipe_process' do
          expect(pipe_process).to     receive(:accumulator=).once
          expect(pipe_process).to     receive(:non_existent_method).once
          expect(pipe_process).to_not receive(:data=)
          expect(pipe_process).to_not receive(:error_backtrace=)
          expect(pipe_process).to_not receive(:process_index=)

          first_status_editing = true
          expect(pipe_process).to receive(:status=) do |received_status|
            if first_status_editing
              expect(received_status).to eq(:pending)
              first_status_editing = false
            else
              expect(received_status).to eq(status)
            end
          end.twice

          expect{ subject.call pipe_process }.to_not raise_error
        end
      end
    end
  end

  # TODO: PipeProcess specs when Javascript modifier_script is present
  describe 'when Javascript modifier_script is present' do
    it 'should be tested'
  end

  # TODO: PipeProcess specs when SQL modifier_script is present
  describe 'when SQL modifier_script is present' do
    it 'should be tested'
  end
end
