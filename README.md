# WIP

This project is not yet functional. I intend to have this as a fully functional gem by mid May.

# PgMultirange

Adds support for PostgreSQL 14+ multiranges to ActiveRecord. Adds:
1. Automatic casting of PostgreSQL multiranges from strings into [Ruby MultiRange](https://github.com/khiav223577/multi_range) when loaded.
2. ActiveRecord methods to support searching the multirange column (including support for all gist operations).

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

## Usage

In a migration add a multirange column to your table

``` ruby
  add_column :calendars, :availability, :tsmultirange
```

Use the corresponding `ActiveRecord Initializer Method` ([table below](https://github.com/Danieth/pg_multirange#range-type)) to add automatic casting and ActiveRecord methods:

``` ruby
  ts_multirange :availability
```

### ActiveRecord methods

Adds first class support for these Postgres operations

| PG Operator | PgMultirange ActiveRecord Method | Description | Gist Index Support? | Supported values |
|----------|---------------------|-------------|-----------|-------|
| = | `where_#{column_name}_equal` | All records where `column_name` is equal to the supplied range. | ✅ | `Range` |
| &&  | `where_#{column_name}_overlaps` | All records where `column_name` overlaps with the supplied range or value. | ✅ | `Range`, `Range Type` |
| -\|- | `where_#{column_name}_adjacent` | All records where `column_name` is adjacent to the provided range or value. | ✅ | `Range`, `Range Type` |
| @>  | `where_#{column_name}_contains` | All records where `column_name` entirely contains the supplied range or value. | ✅ | `Range`, `Range Type` |
| <<  | `where_#{column_name}_strictly_less_than` | All records where the maximum value of `column_name` is less than (to the left of) the minimum of the supplied range or value. | ✅ | `Range`, `Range Type` |
| >>  | `where_#{column_name}_strictly_greater_than` | All records where the minimum value of `column_name` is greater than (to the right of) the maximum of the supplied range or value. | ✅ | `Range`, `Range Type` |
| &< | `where_#{column_name}_less_than` | All records where the maximum value of `column_name` is less or equal to the maximum value of the provided range or value. | ✅ | `Range`, `Range Type` |
| &> | `where_#{column_name}_greater_than` | All records where the minimum value of `column_name` is greater or equal to the minumum value of the provided range or value. | ✅ | `Range`, `Range Type` |
<!-- I don't understand how this is sped up by a gist index -->
<!-- | <@ | `where_#{column_name}_contained_by` | All records entirely contained by the given range | ✅ | `Range` | -->

#### Supported Values
##### `Ranges`
```ruby
MultiRange: MultiRange.new([1..5, 10..12])
Range: 1..2
Array: [1..2, 4...5]
String: "{[1,2],[4,5)}::int8multirange", "{[2011-02-01 00:00:00,2011-02-01 23:59:59]}::tsmultirange"
```

##### `Range Type`
| PG Column | ActiveRecord Initializer Method | PG Example | Ruby Example |
|----------|---------------------|---------|---------|
| int4multirange | `int_multirange` | '{[1,2],[1613680263,1613680981)}'::int4multirange | 1613680981 |
| int8multirange | `int_multirange` | '{[1,2],[9007199254740991,90071992547409934)}'::int8multirange | 90071992547409934 |
| nummultirange | `numeric_multirange` | '{[1.23,4.56],[94.393,1004.0)}'::nummultirange | 1004.0 |
| datemultirange | `date_multirange` | '{[2011-02-01,2011-02-02],[2012-02-01,2012-02-02]}'::datemultirange | Date.new(2001,2,3) |
| tsmultirange | `ts_multirange` | '{[2010-01-01 14:30, 2010-01-01 15:30)}'::tsmultirange | DateTime.new(2001,2,3) |
| tstzmultirange | `tstz_multirange` | '{[2004-10-19 10:23:54+02,2004-12-20 03:12:30+02]}'::tstzmultirange | Time.now.in_time_zone("EST") |

`Range Types` are automatically converted to a single value range when passed to the methods above.

https://www.postgresql.org/docs/current/rangetypes.html

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
