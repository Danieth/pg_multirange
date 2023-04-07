require 'multi_range'

class PgMultirange::Attribute
  attr_accessor :range

  def initialize(values)
    raise "PgMultirange::Value must be inherited from to be instantiated" if self.class == PgMultirange::Value
    # %i(convert_postgres_string_to_ranges to_postgres_string).each do |method|
    #   raise "PgMultirange::Value inherited class is missing #{method}" unless child_method_defined?(method)
    # end

    case values
    when PgMultirange::Attribute
      @range = values.range
    when String
      values = convert_postgres_string_to_ranges(values)
      @range = MultiRange.new(values)
    when MultiRange
      @range = values
    when Array
      @range = MultiRange.new(values)
    else
      @range = MultiRange.new([])
    end
  end

  def +(other_range)
    self.class.new(@range | self.class.new(other_range).range)
  end

  def -(other_range)
    self.class.new(@range - self.class.new(other_range).range)
  end

  def include?(range)
    @range.include?(range)
  end

  def ranges
    @range.ranges
  end

  def to_a
    @range.ranges.map do |range|
      range.minmax
    end
  end

  # TODO bsearch
  def overlaps?(range)
    @range.ranges.any? do |r|
      r.overlaps?(range)
    end
  end

  REGEX = /(\[|\()([\d\w\:\-\+\s]*),\s*([\d\w\:\-\+\s]*)(\]|\))/
  def convert_postgres_string_to_ranges(raw_string)
    ranges = raw_string.scan(REGEX)

    convert_postgres_range_to_range()
  end

  # def to_postgres_string
  #   # Error
  # end
  # def self.child_method_defined?(method_name)
  #   method_defined?(method_name) && method_defined?("method_added")
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
