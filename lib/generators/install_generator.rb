require 'rails/generators'

module Watchdocs
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :app_id, type: :string
      class_option :app_secret, type: :string

      def create_initializer_file
        # TODO: Catch on missing app_id or app_secret
        initializer "watchdocs.rb" do <<-'RUBY'
          Watchdocs::Rails.configure do |c|
            c.app_id = #{options['app_id']}
            c.app_secret = #{options['app_secret']}
          end
        RUBY
        end
      end

      def install_with_specs
        if yes?('Do you have any request specs? Would you like to use Watchdocs
                 with them in test environment?')
          application(nil, env: "test") do
            "config.middleware.insert(0, Watchdocs::Rails::Middleware)"
          end
          inject_into_file 'config/initializers/watchdocs.rb', before: "end\n" do <<-'RUBY'
            c.using_with_specs = true
          RUBY
          end
        end
      end

      def install_with_runtime
        if yes?('Do you want to record your API endpoints in developent environment? ')
          application(nil, env: "test") do
            "config.middleware.insert(0, Watchdocs::Rails::Middleware)"
          end
          puts <<-EOS
            If you would like to enable recording in any other environment (f.e. dev server, staging)
            just add the following line to you 'config/environments/#{env}.rb':

              config.middleware.insert(0, Watchdocs::Rails::Middleware)
          EOS
        end
      end
    end
  end
end
