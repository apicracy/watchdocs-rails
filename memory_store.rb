module Watchdocs
  module Store
    module MemoryStore
      MEM_KEY_NAME = 'requests'

      class << self
        def write(content)
          store.set(content)
        end

        def read
          store.get
        end

        def delete!
          store.clear
        end

        def exists?
          store.get
        end

        def store
          @store ||= MiniMemoryStore.new
        end

        private

        def key
          MEM_KEY_NAME
        end
      end
    end
  end
end
