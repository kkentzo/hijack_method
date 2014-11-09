# HijackMethod

An exercise in Ruby meta-programming that provides functionality to
intercept class (singleton) and instance method calls and execute code
before and/or after the method is called.

## Installation

Add this line to your application's Gemfile:

    gem 'hijack_method'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hijack_method

## Usage

Let's say we have this class:

```ruby
class Foo
  def hello
    puts "hello"
  end
  def self.hello
    puts "self.hello"
  end
end
```

We can hijack the messages `Foo#hello` and `Foo.hello` as follows:

# Hijack a singleton method

```ruby
require 'hijack_method'

class Foo
  class << self
    extend HijackMethod
	hijack_method(:hello,
	  before: -> { code_to_run_before_hello },
	  main: -> { code_to_replace_original_hello },
	  after: -> { code_to_run_before_hello })
  end
end
```

# Hijack an instance method

```ruby
require 'hijack_method'

class Foo
  extend HijackMethod
  hijack_method(:hello,
  before: -> { code_to_run_before_hello },
  main: -> { code_to_replace_original_hello },
  after: -> { code_to_run_before_hello })
end
```
