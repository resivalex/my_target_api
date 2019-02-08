# Ruby client for myTarget API

[![Build Status](https://travis-ci.org/resivalex/my_target_api.svg?branch=develop)](https://travis-ci.org/resivalex/my_target_api) [![Maintainability](https://api.codeclimate.com/v1/badges/2d7c92e0524f7ee1612f/maintainability)](https://codeclimate.com/github/resivalex/my_target_api/maintainability)

## Installation

Add this line to your application's Gemfile:

```
gem 'my_target_api', '~> 1.2.0'
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
# Root resources
campaigns_resource = my_target_api.resource('campaigns')
remarketing_resource = my_target_api.resource('remarketing', v: 2)

# Nested resources
remarketing_counters_resource = my_target_api.resource('remarketing/counters', v: 2)
remarketing_counters_resource = remarketing_resource.resource('counters')
```

#### Options

Name | Default value | Description
---|---|---
`:v` | 1 | API version
`:logger` |   | An object to log requests and exceptions. The object must respond to `<<` method

### Create, Read, Update, Delete

```ruby
remarketing_counters_resource.create(counter_id: 121212) # => [{ 'id' => 343434 }]

campaigns_resource.read # => [{ 'id' => 12345, ... }, { ... }]

campaigns_resource.read(id: 12345) # => [{ 'id' => 12345, ... }]

campaigns_resource.update(id: 12345, status: 'blocked') # => [{ 'id' => 12345, 'status' => 'blocked' }]

remarketing_counters_resource.delete(id: 343434) # => [{ 'success' => true }]
```

#### Options

 Name | Default value | Description 
---|---|---
 `:id` |   | Resource ID. Optional for Read, required for Update and Delete
 `:id_param_key` | `:id` | Option key for resource ID

### Changing default ID param name

```ruby
campaigns_resource.read(id_key_param: :campaign_id, campaign_id: 12345) # => [{ 'id' => 12345, ... }]
```

### File upload

```ruby
static_resource = my_target_api.resource('content/static', v: 2)
picture = File.new('path/to/picture.jpg', 'rb')

static_resource.create(file: picture, data: { width: 1200, height: 800 })
```

### Raw data upload

```ruby
search_phrases_resource = my_target_api.resource('search_phrases', v: 2)
phrases = "phrase\nfirst phrase\nsecond phrase\n"

search_phrases_resource.upload(phrases, name: 'search phrases list')
```

## Exceptions

```ruby
def read_active_campaigns

  campaigns_resource.read(status: 'active')

rescue MyTargetApi::RequestError, MyTargetApi::ConnectionError => e

  puts e.message, e.backtrace
  # You can access the original exception
  puts e.original_exception.message, e.original_exception.backtrace

end
```

 Name | Description 
---|---
 `MyTargetApi::RequestError` | Request didn't succeed
 `MyTargetApi::ConnectionError` | Connection didn't succeed

## Testing

```
bundle exec rspec
```

## Contributing

Create a pull-request or make an issue
