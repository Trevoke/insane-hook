# InsaneHook

Enjoy the enforcing-DSL of this command-patterny gem.

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
class YeOldeTaske
  include InsaneHook
  need :some_required_arg
  allow :some_optional_arg

  call do
    # attr_readers are available for:
    # - some_required_arg
    # - some_optional_arg
    result "meaningful value"
  end
end

YeOldeTaske.new # => InsaneHook::MissingArgumentError

task = YeOldeTaske.new(some_required_arg: "input") # => YeOldeTaske instance
task.result # => raises InsaneHook::CommandNotRunError
task.call # => YeOldeTaske instance
task.result # => "meaningful value"
```

```ruby
class YeOldeTaske
  include InsaneHook
  need :some_required_arg
  allow :some_optional_arg

  call do
    # attr_readers are available for:
    # - some_required_arg
    # - some_optional_arg
  end
end

task = YeOldeTaske.new(some_required_arg: 7).call
task.result # => nil

# Also
task = YeOldeTaske.call(some_required_arg: 7)
```

## Design decisions
1. Usage of `#call` with no arguments is idiomatic Ruby. Procs and method objects respond to `#call`, so we are extending an existing Ruby pattern.
2. Usage of `.call` with arguments is less idiomatic, but common enough because of the above.
3. Commands should not return anything, but if you are forced to check a result, then set the result to a single object and work off of that object, for instance if you want to use the command as one of the clauses of a case statement (in which case the result would be a boolean)
4. Composition is usually better than Inheritance, especially in a language that doesn't support multiple inheritance. You can inherit from something if you need to.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trevoke/insane_hook.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

### A note for later

How much self-shame do I have?

```ruby
module ClassMethods
  def requires(*x)
    class_eval """
      def self.new(#{x}:)
        obj = self.allocate
        obj.instance_variable_set :@x, #{x}
        obj.send :initialize
        obj
      end
    """
  end
end
```
