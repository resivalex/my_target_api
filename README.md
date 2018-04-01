# Ruby client for myTarget API

[![Build Status](https://travis-ci.org/resivalex/my_target_api.svg?branch=develop)](https://travis-ci.org/resivalex/my_target_api) [![Maintainability](https://api.codeclimate.com/v1/badges/2d7c92e0524f7ee1612f/maintainability)](https://codeclimate.com/github/resivalex/my_target_api/maintainability)

## Installation

Add this line to your application's Gemfile:

```
gem 'my_target_api', '~> 1.0.1'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install my_target_api
```

## Usage

```ruby
# initialization
api = MyTargetApi.new(access_token)


# get api object
campaigns_api = api.resource('campaigns')
remarketing_api = api.resource('remarketing', v: 2)
remarketing_counters_api = remarketing_api.resource('counters')

# create
remarketing_counters_api.create(counter_id: 121212) # => [{ id: 343434 }]

# read all
campaigns_api.read # => [{ id: 12345, ... }, { ... }]

# read
campaigns_api.read(id: 12345) # => [{ id: 12345, ... }]

# update
campaigns_api.update(id: 12345, status: 'blocked') # => [{ id: 12345, status: 'blocked' }]

# delete
remarketing_counters_api.delete(id: 343434) # => true
```

## Exceptions

```ruby
def read_active_campaigns
  campaigns_api.read(status: 'active')
rescue MyTargetApi::RequestError, MyTargetApi::ConnectionError => e
  logger.error(e)
  raise
end
```

## Testing

```
bundle exec rspec
```

## Contributing

Create a pull-request or make an issue
