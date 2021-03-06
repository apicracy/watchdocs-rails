module Watchdocs
  module Rails
    class Middleware
      include Rails::Helpers::BodyHelper
      include Rails::Helpers::QueryStringHelper

      attr_reader :app, :report

      def initialize(app)
        @app = app
        @report = {}
      end

      def call(env)
        app.call(env).tap do |response|
          begin
            if record_response?(response)
              clear_report
              catch_request(env)
              catch_response(response)
              match_endpoint_pattern
              record_call
            end
          rescue StandardError => e
            $stderr.puts "Watchdocs Middleware Error: #{e.message}"
          end
        end
      end

      private

      def record_response?(response)
        status, headers, _body = *response
        no_content_response?(status) || json_response?(headers)
      end

      def no_content_response?(status)
        status.to_i == 204
      end

      def json_response?(headers)
        headers['Content-Type'] && headers['Content-Type'].include?('json')
      end

      def clear_report
        @report = {}
      end

      def catch_request(env)
        @report[:request] = {
          method: env['REQUEST_METHOD'],
          url: env['PATH_INFO'],
          query_string_params: parse_query_string(env['QUERY_STRING']),
          body: parse_request_body(env['rack.input'].read)
        }
      end

      def catch_response(response)
        status, headers, body = *response
        @report[:response] = {
          status: status,
          body: parse_response_body(body_string(body))
        }
      end

      def match_endpoint_pattern
        @report[:endpoint] = begin
          ::Rails.application.routes.router.routes
                 .simulator.memos(report[:request][:url])
                 .last.path.spec.to_s.sub('(.:format)', '')
        end
      end

      def record_call
        Rails::Recordings.record(
          report, from_specs: from_specs?
        )
      end

      def from_specs?
        ::Rails.env.test?
      end

      def filter_data(data)
        data.is_a?(Enumerable) ? data.filter_data : data
      end
    end
  end
end
