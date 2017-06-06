require 'rails/generators'
require 'colorize'

module Watchdocs
  module Generators
    MissingCredentialsError = Class.new(Thor::Error)

    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      class_option :app_id, type: :string
      class_option :app_secret, type: :string

      def create_initializer_file
        if !options['app_id'].present? || !options['app_secret'].present?
          raise MissingCredentialsError, <<-ERROR.strip_heredoc
          --app_id or/and --app_secret options is missing
          Please specify both with credentials from Settings tab of your project.
          ERROR
        end

        initializer 'watchdocs.rb' do
          <<-END.gsub(/^\s+\|/, '')
            |Watchdocs::Rails.configure do |c|
            |  c.app_id = '#{options['app_id']}'
            |  c.app_secret = '#{options['app_secret']}'
            |end
          END
        end
      end

      def install_with_specs
        if yes?('Do you want to generate docs on your test run? (requires feature/request specs) [y,n]')
          environment(nil, env: 'test') do
            'config.middleware.insert(0, Watchdocs::Rails::Middleware)'
          end
          if yes?('  Do you test with RSpec? [y,n]')
            template 'rspec.rb', 'spec/support/watchdocs.rb'
            begin
              append_file 'spec/rails_helper.rb', "require 'support/watchdocs.rb'"
            rescue Errno::ENOENT
              warning = <<-END.gsub(/^\s+\|/, '')
                |  You don't have rails_helper.rb, so please add the following line
                |  to the file where you have your RSpec configuration.
                |  -------------------------------
                |  require 'support/watchdocs.rb'
                |  -------------------------------
              END
              puts warning.yellow
            end
          elsif yes?('  Ok, maybe you test with a Minitest? [y,n]')
            begin
              append_file 'test/test_helper.rb',
                        'Minitest.after_run { Watchdocs::Rails::Recordings.export }'
            rescue Errno::ENOENT
              warning = <<-END.gsub(/^\s+\|/, '')
                |  You don't have test_helper.rb, so please add the following line
                |  to the file where you have your Minitest configuration.
                |  ----------------------------------------------------------
                |  Minitest.after_run { Watchdocs::Rails::Recordings.export }
                |  ----------------------------------------------------------
              END
              puts warning.yellow
            end
          else
            warning = <<-END.gsub(/^\s+\|/, '')
              |  We are sorry, but we don't have auto setup for you testing framework.
              |  You need to manually add the following line to be executed after all your specs:
              |  -----------------------------------
              |  Watchdocs::Rails::Recordings.export
              |  -----------------------------------
            END
            puts warning.yellow
          end
          puts 'Watchdocs enabled for test environment!'.green

        end
      end

      def install_with_runtime
        if yes?('Do you want to generate docs from your local API calls? (in development env) [y,n]')
          environment(nil, env: 'development') do
            'config.middleware.insert(0, Watchdocs::Rails::Middleware)'
          end
          if yes?('  Do you use Procfile to run your app? [y,n]')
            append_file 'Procfile', 'watchdocs: watchdocs --every 60.seconds'
            puts 'Watchdocs worker added to your Procfile!'.green
          else
            warning = <<-END.gsub(/^\s+\|/, '')
              |  To make sure we will receive all recorded request please run this worker command with your app:
              |  -----------------------------
              |  watchdocs --every 60.seconds
              |  -----------------------------
            END
            puts warning.yellow

          end
          info = <<-END.gsub(/^\s+\|/, '')
            |  If you would like to enable recording in any other environment (f.e. dev server, staging)
            |  just add the following line to you 'config/environments/{env}.rb':
            |  -----------------------------------------------------------
            |    config.middleware.insert(0, Watchdocs::Rails::Middleware)
            |  -----------------------------------------------------------
          END
          puts info.light_blue
        end
        puts 'Setup is completed. Now run your app and make some requests! Check app.watchdocs.io after a minute or so.'.green
      end

      private

      def environment(data = nil, options = {})
        sentinel = /class [a-z_:]+ < Rails::Application/i
        env_file_sentinel = /\.configure do/
        data = yield if !data && block_given?

        in_root do
          if options[:env].nil?
            inject_into_file 'config/application.rb',
                             "\n    #{data}",
                             after: sentinel,
                             verbose: false
          else
            Array(options[:env]).each do |env|
              inject_into_file "config/environments/#{env}.rb",
                               "\n  #{data}",
                               after: env_file_sentinel,
                               verbose: false
            end
          end
        end
      end
    end
  end
end
