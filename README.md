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

and then fire the installation script

```ruby
rails g watchdocs:install --app_id your_app_id --app_secret your_app_secret
```

and your are good to go! Go to the usage section to for details.


## Configuration

After running installation script you can change the configuration in `config/initializers/watchdocs.rb` which looks like that:

```ruby
  Watchdocs::Rails.configure do |c|
    c.app_id = 'your_app_id'
    c.app_secret = 'your_app_secret'
  end
```

All configuration options are listed below.

### buffer_size

**Default:** 50

Buffer is a place where the gem stores recorderd requests. Buffer size is maximum number of requests that can be stored in a buffer. When limit is reached, buffer content is being exported and cleared. *In other words: Buffer is being exported and cleared every `buffer_size` reqests.*

While executing specs buffer is a memory, otherwise it's a temporary file stored in `temp_directory`.

### temp_directory

**Default:** tmp

Directory to store temporary file with recordings.

### export_url

**Default:** https://watchdocs-api.herokuapp.com/api/v1/reports

URL for exporting recorgings to your Watchdocs project.

### app_id

**No default value**

AppID key which you can get for your Watchdocs project in settings section.

### app_secret

**No default value**

App Secret key which you can get for your Watchdocs project in settings section.

## Usage

You can enable Watchdocs to record request while executing specs or making manual tests. You can of course do both at the same time if you want.

**NOTE:**: If you've fired installation script, you don't have to copy any code from this section as the script gracefully did it for you.

### Specs

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

#### Configuring with WebMock


If you are using WebMock and it complains about real HTTP call please disable it for when exporting data to our API.

```ruby
  config.after(:suite) do
    ....
    WebMock.disable!
    Watchdocs::Rails::Recordings.export
    WebMock.enable!
  end
```

#### Configuring with VCR


If you are using VCR add this line to your `VCR.configure` block:

```ruby
VCR.configure do |c|
  config.ignore_request do |req|
    req.uri == Watchdocs::Rails.configuration.export_url
  end
end
```

#### Running specs

Run your specs as usual. Watchdocs will let you know about recorderd API calls.

**NOTE:** Watchdocs doesn't work with controller specs as they don't actually make full reqests (that's why we don't recommend them). If you have controllers specs only don't worry and go to the next section to see how you can use Watchdocs in your project.


### Development (manual tests)

If you don't have any request specs yet, you can add the following line to `config/environments/development.rb`.

```ruby
config.middleware.insert(0, Watchdocs::Rails::Middleware)
```

To make sure we will receive all recorded request please add this worker command to your `Procfile` or run it manually:

```
watchdocs --every 60.seconds
```

Watchdocs will be recording all requests in your development environment during manual tests and export them every `buffer_size` requests and every 60 seconds (you can adjust the frequency to your needs).

You can of course enable the middleware in any other environment like `dev` or `staging`.


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
- recurrent

## Contributing

1. Fork it ( https://github.com/<user>/<gem>/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
