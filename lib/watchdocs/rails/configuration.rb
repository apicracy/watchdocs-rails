require 'configurations'

module Watchdocs
  module Rails
    include Configurations
    configurable :store_class,
                 :temp_directory,
                 :sync_url

    configuration_defaults do |c|
      c.store_class = Watchdocs::Rails::Store::MemoryStore
      c.temp_directory = 'tmp'
      c.sync_url = 'http://demo8792890.mockable.io/requests'
    end
  end
end
