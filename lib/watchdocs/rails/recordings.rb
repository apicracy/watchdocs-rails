module Watchdocs
  # Recording module is responsible for captured requests
  # managment. Stores new recod
  module Recordings
    class << self
      def record_call(new_call)
        output = if recordings_exists?
                   current_recordings << new_call
                 else
                   [new_call]
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
        Watchdocs.configuration.sync_url
      end
    end
  end
end
