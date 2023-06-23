# Process Declaraçao Periodica do IVA

## Installation

```
gem install process_decl_IVA
```

## Usage

Pass in the year and quarter like:

```
$ Y=2023 T=3 bin/process_decl_iva
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nunommc/process_decl_IVA

1. Fork the repo
2. Make changes
3. Run test suite with `bundle exec rspec`
4. Run `bundle exec standardrb` to standardize code formatting
5. Submit a PR

## License

Copyright (c) 2023 Nuno Costa, released under the [MIT License](https://opensource.org/licenses/MIT).
