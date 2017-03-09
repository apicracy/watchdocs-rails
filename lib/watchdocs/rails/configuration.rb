module Watchdocs
  include Configurations
  configurable :store_class,
               :temp_directory,
               :sync_url

  configuration_defaults do |c|
    c.store_class = Watchdocs::Store::MemoryStore
    c.temp_directory = 'tmp'
    c.sync_url = 'http://demo8792890.mockable.io/requests'
  end
end
