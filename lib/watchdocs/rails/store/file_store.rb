module Watchdocs
  module Rails
    module Store
      module JsonFileStore
        class StorageError < StandardError; end

        class << self
          def write(content)
            File.write(path_to_file, content.to_json)
            path_to_file
          rescue StandardError => e
            raise StorageError, e
          end

          def read
            file = File.open(path_to_file, 'r')
            JSON.parse(file.read)
          rescue JSON::ParserError
            []
          rescue StandardError => e
            raise StorageError, e
          ensure
            file.close
          end

          def delete!
            File.delete(path_to_file)
          rescue StandardError => e
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
            Watchdocs::Rails.configuration.temp_directory
          end
        end
      end
    end
  end
end
