# watchdocs-rails

[Watchdocs](http://watchdocs.io) Rails JSON API requests watcher.

It captures every JSON response, stores request and response details in temporary storage. Provides methods to send recorded calls to [Watchdocs](http://watchdocs.io) which checks them agains the documentation or create docs for new calls.

## Installation

Add to your Gemfile. It is recommended to add to `:test, :development` group.

```ruby
gem 'watchdocs-rails', '~> 0.1.0'
```

and run

```
bundle
```

## Configuration

Create `config/initializers/watchdocs.rb` and configure the gem if you need to change default configuration:

```ruby
  Watchdocs::Rails.configure do |c|
    c.store_class = Watchdocs::Rails::Store::MemoryStore
    c.temp_directory = 'tmp'
    c.sync_url = 'http://demo8792890.mockable.io/requests'
  end
```

### store_class

This option allows you to specify class that is responsible for storing recordings.

You can select from provided options:

- `Watchdocs::Rails::Store::MemoryStore` **(default)** - stores recordings in memory
- `Watchdocs::Rails::Store::JsonFileStore` - stores in temporary json file

or you can implement you own store for recordings. Just create module that implements the following methods:

```ruby
  # Params
  # content - is a Ruby Array of Hashes
  def write(content)
    ...
  end

  # Returns Ruby Array of Hashes
  def read
    ...
  end

  def delete!
    ...
  end

  # Returns true if store already initialized
  def exists?
    ...
  end
```

### temp_directory

**Applicable only when `JsonFileStore` enabled as `store_class`**
Directory to store temporary file with recordings.

### sync_url

URL for syncing with your Watchdocs project.

## Usage

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
    Watchdocs::Rails::Recordings.send
  end
```

#### Minitest


```
Minitest.after_run do
  Watchdocs::Rails::Recordings.send
end
```

### Development

If you don't have any specs yet. You can add the following line to `config/environments/development.rb`.

```ruby
config.middleware.insert(0, Watchdocs::Rails::Middleware)
```

Then the only option is to send recordings manually from `rails c` by running `Watchdocs::Rails::Recordings.send`.

**IMPORTANT NOTE: You need to select `JsonFileStore` as storage option in that case.**


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
- mini_memory_store

## Contributing

1. Fork it ( https://github.com/<user>/<gem>/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
