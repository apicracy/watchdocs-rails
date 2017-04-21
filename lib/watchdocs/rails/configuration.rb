require 'configurations'

module Watchdocs
  module Rails
    include Configurations
    configurable :buffer_size,
                 :temp_directory,
                 :export_url,
                 :app_id,
                 :app_secret

    configuration_defaults do |c|
      c.buffer_size = 50
      c.temp_directory = 'tmp'
      c.export_url = 'https://watchdocs-api.herokuapp.com/api/v1/reports'
    end

    not_configured do |prop|
      warn :not_configured,
           "You need to configure #{prop} with
           credentials from your project Settings page."
    end
  end
end
