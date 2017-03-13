module Watchdocs
  module Rails
    module Recordings
      class Recorder
        attr_reader :store, :output

        def initialize(from_specs: true)
          set_store(from_specs)
        end

        def call(new_call)
          record_new
          save_recordings
          send_recordings if buffer_full?
        end

        private

        def record_new
          @output = if current_recordings
                     current_recordings << new_call
                    else
                     [new_call]
                    end
        end

        def current_recordings
          @current ||= store.read
        end

        def save_recordings
          store.write(output)
        end

        def send_recordings
          Recordings.send(output)
        end

        def set_store(from_specs)
          @store = if from_specs
                     Rails::Buffer::MemoryBuffer
                   else
                     Rails::Buffer::FileBuffer
                   end
        end

        def buffer_full?
          current_recordings.count > buffer_size
        end

        def buffer_size
          Rails.configuration.buffer_size
        end
      end
    end
  end
end
