# watchdocs-rails

This is a Watchdocs Rails Middleware (it will be gemify soon).

It captures every JSON response and stores request and response details in json file.

## How to test in the wild

1. Copy all the files to some Rails app that uses JSON requests `/lib` directory (make sure your app auto-loads `/lib` direcory)
2. If you have some requests specs or features specs that call JSON API then add this line to you `config/environments/test.rb`. Otherwise add to `config/environments/development.rb`.
```ruby
config.middleware.insert(0, Watchdocs::Middleware)
```
3. Update your spec hooks if using with tests (for RSpec it's in `specs/rails_helper.rb`)
```ruby
  config.before(:suite) do
    ....
    Watchdocs::Recordings.clear!
  end

  config.after(:suite) do
    ....
    Watchdocs::Recordings.send
  end
```
4. Run specs or the app and make some requests.
