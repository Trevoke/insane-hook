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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trevoke/insane_hook.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
