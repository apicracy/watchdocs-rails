module Watchdocs
  module Rails
    class Middleware
      attr_reader :app, :report

      def initialize(app)
        @app = app
        @report = {}
      end

      def call(env)
        app.call(env).tap do |response|
          if json_response?(response)
            clear_report
            catch_request(env)
            catch_response(response)
            match_endpoint_pattern
            record_call
          end
        end
      end

      private

      def json_response?(response)
        headers = response.second
        headers['Content-Type'] && headers['Content-Type'].include?('json')
      end

      def clear_report
        @report = {}
      end

      def catch_request(env)
        @report[:request] = {
          method: env['REQUEST_METHOD'],
          url: env['PATH_INFO'],
          query_string_params: Rack::Utils.parse_nested_query(env['QUERY_STRING']),
          body: parse_request_body(env['rack.input'].read),
          headers: request_headers(env)
        }
      end

      def catch_response(response)
        status, headers, body = *response
        @report[:response] = {
          status: status,
          headers: headers.to_hash.upcased_keys,
          body: parse_response_body(body_string(body))
        }
      end

      def match_endpoint_pattern
        @report[:endpoint] = begin
          ::Rails.application.routes.router.routes
                 .simulator.memos(report[:request][:url])
                 .last.path.spec.to_s.sub('(.:format)', '')
        end
      rescue
        @report[:endpoint] = 'No routes match'
      end

      def record_call
        Rails::Recordings.record(
          report, from_specs: from_specs?
        )
      end

      def from_specs?
        ::Rails.env.test?
      end

      def request_headers(env)
        env.keys
           .select { |k| k.start_with? 'HTTP_' }
           .map { |k| format_header(k) }
           .sort
      end

      def format_header(header)
        header.sub(/^HTTP_/, '')
              .tr('_', '-')
      end

      def body_string(body)
        body_string = ''
        body.each { |line| body_string += line } if body
        body_string
      end

      def parse_response_body(body)
        return if body.empty?
        filter_body(JSON.parse(body))
      rescue JSON::ParserError => e
        { watchdocs_error: "Invalid JSON data: #{e.message}" }
      rescue StandardError
        { watchdocs_error: 'Response body format not supported' }
      end

      def parse_request_body(body)
        return if body.empty?
        filter_body(JSON.parse(body))
      rescue JSON::ParserError
        begin
          filter_body(Rack::Utils.parse_nested_query(body))
        rescue StandardError
          { watchdocs_error: 'Request body format not supported' }
        end
      end

      def filter_body(body)
        body.is_a?(Enumerable) ? body.filter_data : body
      end
    end
  end
end
