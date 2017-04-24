module Watchdocs
  module Rails
    module Helpers
      module QueryStringHelper
        def parse_query_string(params)
          filter_data(
            Rack::Utils.parse_nested_query(params)
          )
        rescue StandardError
          $stderr.puts "Query String format not supported. String: #{params}"
          {}
        end
      end
    end
  end
end
