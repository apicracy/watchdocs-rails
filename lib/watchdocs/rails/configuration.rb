require 'configurations'

module Watchdocs
  module Rails
    include Configurations
    configurable :buffer_size,
                 :temp_directory,
                 :export_url

    configuration_defaults do |c|
      c.buffer_size = 50
      c.temp_directory = 'tmp'
      c.export_url = 'http://demo8792890.mockable.io/requests'
    end
  end
end
