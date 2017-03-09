require 'mini_memory_store'

module Watchdocs
  module Rails
    module Store
      module MemoryStore
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

          private

          def store
            @store ||= MiniMemoryStore.new
          end
        end
      end
    end
  end
end
