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

      private

      def recordings_exists?
        Watchdocs::Store::JsonFileStore.exists?
      end

      def current_recordings
        Watchdocs::Store::JsonFileStore.read
      end

      def save_recordings(content)
        Watchdocs::Store::JsonFileStore.write(content)
      end

      def clear_recordings
        Watchdocs::Store::JsonFileStore.delete!
      end
    end
  end
end
