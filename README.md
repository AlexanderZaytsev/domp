# DOMP: Devise & Omniauth Multiple Providers

Generator for using Devise & Omniauth with Multiple Providers. I wrote this because I got tired of repeating the same code in every app that required multiple providers.

Basically, to have multiple providers working in a brand new application, all you need to do is run the following:
```
gem "devise"
```
```
rails generate devise:install
rails generate devise User
rails generate domp User facebook twitter
```

Note: this is not an engine but rather a generator which will generate models, controllers and setup configs for you. You are free to change everything. You are the king.

## Installation

    $ gem install domp

## Usage

First, you need to have `devise` already installed and your model generated:

```
rails generate devise:install
rails generate devise User
```

Run the `domp` generator:

```
rails generate domp User facebook twitter
```

During the generation you will be promted for the provider's application id and secret key.

## What is generated for you:

### AuthenticationProvider
Model & migration. Will be populated with the providers you specify.

### UserAuthentication
Model & migration.

### User model additions
Here's what the `User` model will look like:

```ruby
class User < ActiveRecord::Base
  has_many :authentications, class_name: 'UserAuthentication'
  devise :omniauthable,  :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
```

### User::OmniauthCallbacksController
Here goes all the logic of creating multiple authentications. You are free to change everything, it's just a boilerplate that will make sense it most of the apps.

### Route additions
```ruby
devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
```
### Devise config additions

The following will be added to `config/initializers/devise.rb`:

```ruby
config.omniauth :facebook, 'x', 'x'
config.omniauth :twitter, 'x', 'x'
  ```

### Gemfile additions
```
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-twitter"
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
