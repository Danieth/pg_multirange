require 'multi_range'

class PgMultirange::Attribute < MultiRange

  def initialize(values)
    raise "PgMultirange::Value must be inherited from to be instantiated" if self.class == PgMultirange::Value
    # %i(convert_postgres_string_to_ranges to_postgres_string).each do |method|
    #   raise "PgMultirange::Value inherited class is missing #{method}" unless child_method_defined?(method)
    # end
    case values
    when MultiRange
      super(values.ranges)
    when String
      values = convert_postgres_string_to_ruby_range(values)
      super(values)
    when Array
      super(values)
    when Range
      super([values])
    else
      super([])
    end
  end

  # Contains all of the methods on the MultiRange object
  def |(other_range)
    other_range = self.class.new(other_range)
    self.class.new(super(other_range))
  end
  alias + |

  def -(other_range)
    return super(other_range) if other_range.is_a?(Range)
    other_ranges = self.class.new(other_range)
    res = super(other_ranges)
    self.class.new(res)
  end

  def &(other_range)
    other_range = self.class.new(other_range)
    self.class.new(super(other_range))
  end

  def to_a
    @ranges.map do |range|
      range.minmax
    end
  end

  # TODO optimize this with bsearch
  # def overlaps?(range)
  #   # Find the smallest index where it's start is >= range.start
  #   first_greater_index = @range.ranges.bsearch_index do |r|
  #     r.start >= range.start
  #   end
  #   return false if first_greater_index.nil?

  #   return true if @range.ranges[first_greater_index].overlaps?(range)
  #   first_lesser_index = first_greater_index - 1

  #   if first_lesser_index >= 0
  #     return true if @range.ranges[first_lesser_index].overlaps?(range)
  #   end

  #   false
  # end

  REGEX = /(\[|\()([^,]+),([^,]+)(\]|\))/
  def convert_postgres_string_to_ruby_range(postgres_string)
    ranges = postgres_string.scan(REGEX)

    ranges.map do |(start_boundary, b, e, end_boundary)|
      exclude_start = start_boundary == "("
      exclude_end = end_boundary == ")"

      convert_postgres_range_to_type(
        exclude_start, b, e, exclude_end
      )
    end
  end
end

require_relative 'attribute/integer'
require_relative 'attribute/timestamp'
