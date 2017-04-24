module Watchdocs
  module Rails
    module Helpers
      module HeadersHelper
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
      end
    end
  end
end
