require 'configurations'

module Watchdocs
  module Rails
    include Configurations
    configurable :buffer_size,
                 :temp_directory,
                 :export_url,
                 :api_key,
                 :api_secret

    configuration_defaults do |c|
      c.buffer_size = 50
      c.temp_directory = 'tmp'
      c.export_url = 'https://watchdocs-api.herokuapp.com/api/v1/project/10/reports'
      c.api_key = '8L9qh77q9570H0LIz90Aj00T5mcOHW1w'
      c.api_secret = 'G52uFXHPjyxRY3JdBIsw562uJ8bUdrE2'
    end
  end
end
