require 'httparty'

module Watchdocs
  module Rails
    module Recordings
      module Exporter
        class WatchdocsApiError < StandardError; end

        DEFAULT_ERROR = 'Unknown API Error occured.'.freeze

        class << self
          def export(payload)
            response = HTTParty.post(
              api_url,
              body: payload.to_json,
              headers: { 'Content-Type' => 'application/json' },
              basic_auth: api_auth
            )
            check_response(response)
          end

          private

          def check_response(response)
            case response.code.to_s.chars.first
            when '2'
              true
            when '4', '5'
              raise WatchdocsApiError, get_error(response.body)
            else
              raise WatchdocsApiError, DEFAULT_ERROR
            end
          end

          def get_error(response_body)
            JSON.parse(response_body)['errors'].join(', ')
          rescue
            DEFAULT_ERROR
          end

          def api_url
            Watchdocs::Rails.configuration.export_url
          end

          def api_auth
            {
              username: Watchdocs::Rails.configuration.app_id,
              password: Watchdocs::Rails.configuration.app_secret
            }
          end
        end
      end
    end
  end
end
