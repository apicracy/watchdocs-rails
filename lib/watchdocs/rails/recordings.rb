require 'watchdocs/rails/recordings/recorder'
require 'watchdocs/rails/recordings/exporter'

module Watchdocs
  module Rails
    module Recordings
      attr_reader :store

      class << self
        def record(new_call, from_specs: true)
          Recorder.new(
            from_specs: from_specs
          ).call(new_call)
        end

        def clear!(from_specs: true)
          set_store(from_specs)
          clear_recordings
        end

        def export(recordings = nil, from_specs: true)
          set_store(from_specs)
          recordings ||= current_recordings
          send_recordings(recordings) && clear!(from_specs)
        end

        private

        def current_recordings
          store.read
        end

        def clear_recordings
          store.delete!
        end

        def export_recorings(recordings)
          Exporter.export(recordings)
        end

        def set_store(from_specs)
          @store = if from_specs
                     Rails::Buffer::MemoryBuffer
                   else
                     Rails::Buffer::FileBuffer
                   end
        end
      end
    end
  end
end
