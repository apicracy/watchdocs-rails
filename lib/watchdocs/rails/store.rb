module Watchdocs
  module Store
    # You can implement you own store for recordings
    # Just create module that implements following methods

    ## Params
    ## * content is a Ruby Array of Hashes
    # def write(content)
    #   ...
    # end

    ## Returns Ruby Array of Hashes
    # def read
    #   ...
    # end

    # def delete!
    #   ...
    # end

    ## Returns true if store already initialized
    # def exists?
    #   ...
    # end
  end
end

require 'watchdocs/store/file_store'
require 'watchdocs/store/memory_store'
