module Watchdocs
  module Rails
    module Helpers
      module BodyHelper
        def body_string(body)
          body_string = ''
          body.each { |line| body_string += line } if body
          body_string
        end

        def parse_response_body(body)
          return if body.empty?
          filter_data(JSON.parse(body))
        rescue JSON::ParserError => e
          log_and_return_empty "Invalid JSON data: #{e.message}, Body: #{body}"
        rescue StandardError
          log_and_return_empty "Response body format not supported. Body: #{body}"
        end

        def parse_request_body(body)
          return if body.empty?
          filter_data(JSON.parse(body))
        rescue JSON::ParserError
          begin
            filter_data(Rack::Utils.parse_nested_query(body))
          rescue StandardError
            log_and_return_empty "Request body format not supported. Body: #{body}"
          end
        end

        def log_and_return_empty(error)
          $stderr.puts "Watchdocs Middleware Error: #{error}"
          {}
        end
      end
    end
  end
end
