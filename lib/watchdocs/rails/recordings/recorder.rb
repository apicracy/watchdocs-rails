module Watchdocs
  module Rails
    module Recordings
      class Recorder
        attr_reader :store, :output, :from_specs

        def initialize(from_specs: true)
          @from_specs = from_specs
          set_store
        end

        def call(new_call)
          record_new(new_call)
          save_recordings
          send_recordings if buffer_full?
        end

        private

        def record_new(new_call)
          @output = if recordings_any?
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

        def recordings_any?
          store.exists?
        end

        def send_recordings
          Recordings.export(output, from_specs: from_specs)
        end

        def set_store
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
