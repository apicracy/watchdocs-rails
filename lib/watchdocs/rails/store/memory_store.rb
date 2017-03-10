module Watchdocs
  module Rails
    module Store
      module MemoryStore
        attr_accessor :store

        class << self
          def write(content)
            store = content
          end

          def read
            store
          end

          def delete!
            write(nil)
          end

          def exists?
            store
          end
        end
      end
    end
  end
end
