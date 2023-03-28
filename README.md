# PgMultirange

TODO: Delete this and the text below, and describe your gem

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/pg_multirange`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

## Usage

### `Range Types` include
| PG Column | PgMultirange ActiveRecord Method | PG Example | Ruby Example |
|----------|---------------------|---------|---------|
| int4multirange | integer | '{[1,2],[1613680263,1613680981)}'::int4multirange | 1613680981 |
| int8multirange | bigint| '{[1,2],[9007199254740991,90071992547409934)}'::int8multirange | 90071992547409934 |
| nummultirange | numeric| '{[1.23,4.56],[94.393,1004.0)}'::nummultirange | 1004.0 |
| datemultirange | date | '{[2011-02-01,2011-02-02],[2012-02-01,2012-02-02]}'::datemultirange | Date.new(2001,2,3) |
| tsmultirange | timestamp without time zone| '{[2010-01-01 14:30, 2010-01-01 15:30)}'::tsmultirange | DateTime.new(2001,2,3) |
| tstzmultirange | timestamp with time zone | '{[2004-10-19 10:23:54+02,2004-12-20 03:12:30+02]}'::tstzmultirange | Time.now.in_time_zone("EST") |

`Range Types` are automatically converted to a single value range when passed to the methods below.

https://www.postgresql.org/docs/current/rangetypes.html


### Valid `Ranges` include
```ruby
String: "{[1,2],[4,5)}::int8multirange", "{[2011-02-01 00:00:00,2011-02-01 23:59:59]}::tsmultirange"
Range: 1..2
MultiRange: MultiRange.new([1..5, 10..12])
Array: [1..2, 4...5]
```

### Operators

Adds first class support for these operations per multirange column

| PG Operator | PgMultirange ActiveRecord Method | Description | Gist Support? | Accepts |
|----------|---------------------|-------------|-----------|-------|
| = | `where_#{column_name}_equal` (Rails has existing support - but it won't handle casting) | All records where the multiranges are equal | ✅ | `Range` |
| &&  | `where_#{column_name}_overlaps` | All records where `column_name` overlaps with the supplied range or value | ✅ | `Range`, `Range Type` |
| -\|- | `where_#{column_name}_adjacent` | All records where `column_name` is adjacent to the provided range or value. | ✅ | `Range`, `Range Type` |
| @>  | `where_#{column_name}_contains` | All records where `column_name` entirely contains the supplied range or value | ✅ | `Range`, `Range Type` |
| <<  | `where_#{column_name}_strictly_less_than` | All records where the maximum value of `column_name` is less than (to the left of) the minimum of the supplied range or value. | ✅ | `Range`, `Range Type` |
| >>  | `where_#{column_name}_strictly_greater_than` | All records where the minimum value of `column_name` is more than (to the right of) the maximum of the supplied range or value. | ✅ | `Range`, `Range Type` |
| &< | `where_#{column_name}_less_than` | All records where the maximum value of `column_name` is less or equal to the maximum value of the provided range or value. | ✅ | `Range`, `Range Type` |
| &> | `where_#{column_name}_greater_than` | All records where the minimum value of `column_name` is greater or equal to the minumum value of the provided range or value. | ✅ | `Range`, `Range Type` |
<!-- I don't understand how this is gist -->
<!-- | <@ | `where_#{column_name}_contained_by` | All records entirely contained by the given range | ✅ | `Range` | -->

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Danieth/pg_multirange. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Danieth/pg_multirange/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PgMultirange project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Danieth/pg_multirange/blob/master/CODE_OF_CONDUCT.md).

## Contributing

<!-- createdb pg_multirange_test -->

# Inspiration taken from
# https://github.com/sjke/pg_ltree
# https://github.com/khiav223577/multi_range
