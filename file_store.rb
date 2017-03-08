module Watchdocs
  module Store
    module JsonFileStore
      class StorageError < StandardError; end

      class << self
        def write(content)
          begin
            File.write(path_to_file, content.to_json)
          rescue => e
            raise StorageError, e
          end
          path_to_file
        end

        def read
          begin
            file = File.open(path_to_file, "r")
          rescue => e
            raise StorageError, e
          end
          JSON.parse(file.read)
        end

        def delete!
          File.delete(path_to_file)
        rescue => e
          raise StorageError, e
        end

        def exists?
          File.exist?(path_to_file)
        end

        private

        def path_to_file
          "#{temp_local_path}/reqests.json"
        end

        def temp_local_path
          'tmp' # TODO: Make configurable
        end
      end
    end
  end
end
