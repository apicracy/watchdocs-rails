require 'watchdocs/rails/recordings/recorder'
require 'watchdocs/rails/recordings/exporter'

module Watchdocs
  module Rails
    module Recordings
      class << self
        attr_reader :store

        def record(new_call, from_specs: true)
          Recorder.new(
            from_specs: from_specs
          ).call(new_call)
        end

        def clear!(from_specs: true)
          set_store(from_specs)
          clear_recordings
        rescue StandardError => e
          $stderr.puts "Watchdocs Error: #{e.message}.
                        Please report it to contact@watchdocs.io"
        end

        def export(recordings = nil, from_specs: true)
          set_store(from_specs)
          recordings ||= current_recordings
          return unless current_recordings
          export_recorings(recordings) && clear!(from_specs: from_specs)
          $stderr.puts "Watchdocs: #{recordings.count} requests exported"
        rescue StandardError => e
          $stderr.puts "Watchdocs Error: #{e.message}.
                        Please report it to contact@watchdocs.io"
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
