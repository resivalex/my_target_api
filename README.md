# Ruby client for myTarget API

[![Build Status](https://travis-ci.org/resivalex/my_target_api.svg?branch=develop)](https://travis-ci.org/resivalex/my_target_api) [![Maintainability](https://api.codeclimate.com/v1/badges/2d7c92e0524f7ee1612f/maintainability)](https://codeclimate.com/github/resivalex/my_target_api/maintainability)

## Installation

Add this line to your application's Gemfile:

```
gem 'my_target_api', '~> 1.0.4'
```

Or install from command line:

```
$ gem install my_target_api
```

## Usage

### Initialization

```ruby
# You need an access token to use API
my_target_api = MyTargetApi.new(access_token)
```

### Resources

```ruby
# root resources
campaigns_resource = my_target_api.resource('campaigns')
remarketing_resource = my_target_api.resource('remarketing', v: 2)

# nested resources
remarketing_counters_resource = my_target_api.resource('remarketing/counters', v: 2)
remarketing_counters_resource = remarketing_resource.resource('counters')
```

### Create, Read, Update, Delete

```ruby
remarketing_counters_resource.create(counter_id: 121212) # => [{ 'id' => 343434 }]

campaigns_resource.read # => [{ 'id' => 12345, ... }, { ... }]

campaigns_resource.read(id: 12345) # => [{ 'id' => 12345, ... }]

campaigns_resource.update(id: 12345, status: 'blocked') # => [{ 'id' => 12345, 'status' => 'blocked' }]

remarketing_counters_resource.delete(id: 343434) # => [{ 'success' => true }]
```

### File upload

```ruby
static_resource = my_target_api.resource('content/static', v: 2)
picture = File.new('path/to/picture.jpg', 'rb')

static_resource.create(file: picture, data: { width: 1200, height: 800 })
```

## Exceptions

```ruby
def read_active_campaigns

  campaigns_resource.read(status: 'active')

rescue MyTargetApi::RequestError, MyTargetApi::ConnectionError => e

  puts e.message, e.backtrace

end
```

## Testing

```
bundle exec rspec
```

## Contributing

Create a pull-request or make an issue
