# watchdocs-rails

[Watchdocs](http://watchdocs.io) Rails JSON API requests watcher.

It captures every JSON response, stores request and response details in temporary storage. Provides methods to send recorded calls to [Watchdocs](http://watchdocs.io) which checks them agains the documentation or create docs for new calls.

## Installation

Add to your Gemfile. It is recommended to add to `:test, :development` group.

```ruby
gem 'watchdocs-rails'
```

and run

```
bundle
```

## Configuration

Create `config/initializers/watchdocs.rb` and configure the gem if you need to change default configuration:

```ruby
  Watchdocs::Rails.configure do |c|
    c.buffer_size = 50
    c.temp_directory = 'tmp'
    c.export_url = 'http://demo8792890.mockable.io/requests'
  end
```

### buffer_size

**Default:** 50

Buffer is a place where the gem stores recorderd requests. Buffer size is maximum number of requests that can be stored in a buffer. When limit is reached, buffer content is being exported and cleared. *In other words: Buffer is being exported and cleared every `buffer_size` reqests.*

While executing specs buffer is a memory, otherwise it's a temporary file stored in `temp_directory`.

### temp_directory

**Default:** tmp

Directory to store temporary file with recordings.

### export_url

**Default:** http://demo8792890.mockable.io/requests

URL for exporting recorgings to your Watchdocs project.

## Usage

You can enable Watchdocs to record request while executing specs or making manual tests. You can of course do both at the same time if you want.

### Tests

If you have some requests specs or features specs that call JSON API then add this line to your `config/environments/test.rb`.

```ruby
config.middleware.insert(0, Watchdocs::Rails::Middleware)
```

Update/create your spec hooks:

#### RSpec

In `specs/rails_helper.rb`:

```ruby
  config.before(:suite) do
    ....
    Watchdocs::Rails::Recordings.clear!
  end

  config.after(:suite) do
    ....
    Watchdocs::Rails::Recordings.export
  end
```

#### Minitest


```
Minitest.after_run do
  Watchdocs::Rails::Recordings.export
end
```

### Development (manual tests)

If you don't have any request specs yet. You can add the following line to `config/environments/development.rb`.

```ruby
config.middleware.insert(0, Watchdocs::Rails::Middleware)
```

If your app doesn't make a lot of JSON requests please set `buffer_size` to lower number (f.e. 10, it's 50 by default). Watchdocs will be recording all requests in your development environment during manual tests.

You can of course enable the middleware in any other environment like dev or staging


## Versioning

Semantic versioning (http://semver.org/spec/v2.0.0.html) is used.

For a version number MAJOR.MINOR.PATCH, unless MAJOR is 0:

1. MAJOR version is incremented when incompatible API changes are made,
2. MINOR version is incremented when functionality is added in a backwards-compatible manner,
3. PATCH version is incremented when backwards-compatible bug fixes are made.

Major version "zero" (0.y.z) is for initial development. Anything may change at any time.
The public API should not be considered stable.
Furthermore, version "double-zero" (0.0.x) is not intended for public use,
as even minimal functionality is not guaranteed to be implemented yet.

## Dependencies

- httparty
- configurations

## Contributing

1. Fork it ( https://github.com/<user>/<gem>/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
