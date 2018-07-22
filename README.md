# InsaneHook

Enjoy the enforcing-DSL of this command-patterny gem.

## Current version

0.4.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'insane_hook'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install insane_hook

## Usage

```ruby
class YeOldeTaske < InsaneHook
  requires :some_required_arg
  fallbacks :some_optional_arg

  call do
    result "meaningful value"
  end
end
```

Is equivalent to:

```ruby
class YeOldeTaske

  def self.call(**args)
    new(**args).call
  end

  attr_reader :some_required_arg, :some_optional_arg
  def initialize(some_required_arg:, some_optional_arg: nil)
    @some_required_arg = some_required_arg
    @some_optional_arg = some_optional_arg
  end

  def call
    result "meaningful value"
    self
  end

  def result(arg = InsaneHook::NO_ARG)
    if arg == InsaneHook::NO_ARG
      if instance_variable_defined?(:@result)
        @result
      else
        raise InsaneHook::CommandNotRunError
      end
    else
      @result = arg
    end
  end

end
```


## Design decisions
1. Usage of `call` is idiomatic Ruby. Procs and method objects respond to `call`, so we are extending an existing Ruby pattern.
2. Commands should not return anything, but if you are forced to check a result, then set the result to a single object and work off of that object, for instance if you want to use the command as one of the clauses of a case statement (in which case the result would be a boolean)
3. Composition is usually better than Inheritance, especially in a language that doesn't support multiple inheritance. Here we need to use inheritance because we are completely taking over both the `.new` and the `#initialize` methods, meaning the object does not truly belong to the person writing the code.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trevoke/insane_hook.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
