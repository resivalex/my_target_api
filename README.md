# MyTargetApi

## Installation

Add this line to your application's Gemfile:

    gem 'my_target_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install my_target_api

## Usage

    MyTargetApi.client_id = YOUR_CLIENT_ID
    MyTargetApi.client_secret = YOUR_CLIENT_SECRET_KEY

Get authorize url and redirect user to it.

    MyTargetApi::Auth.authorize_url

Recieve authentication code and request token:

    MyTargetApi::Auth.get_token code
    => {"access_token" => "xxx", "token_type" => "Bearer", "expires_in" => 86400, "refresh_token" => "xxx"}

Use refresh_token to update current token after it expires

    MyTargetApi::Auth.refresh_token code
    => {"access_token" => "xxx", "token_type" => "Bearer", "expires_in" => 86400, "refresh_token" => "xxx"}

Initialize new session and request restful resources:

    session = MyTargetApi::Session.new(token)
    session.request :get, "/campaigns", status: "active"

Request with 'sudo' mode:

    session = MyTargetApi::Session.new(token)
    session.request :get, "/campaigns", { as_user: "xxxxxxx@agency_client", status: "active" }

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mailru_target/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
