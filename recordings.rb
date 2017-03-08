module Watchdocs
  module Recordings
    class << self
      def record_request(new_request)
        output = if recordings_exists?
                   current_recordings << new_request
                 else
                   [new_request]
                 end
        save_recordings(output)
      end

      def clear!
        clear_recordings
      end

      def send
        Watchdocs::Bridge.send(current_recordings) &&
          clear_recordings
      end

      private

      def recordings_exists?
        store.exists?
      end

      def current_recordings
        store.read
      end

      def save_recordings(content)
        store.write(content)
      end

      def clear_recordings
        store.delete!
      end

      def store
        # TODO: Configuration
        # Watchdocs::Store::JsonFileStore
        Watchdocs::Store::MemoryStore
      end
    end
  end
end
