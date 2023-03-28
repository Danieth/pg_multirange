class PgMultirange::Value::Integer < PgMultirange::Value
  def attribute_class
    PgMultirange::Attribute::Integer
  end

  def convert_postgres_string_to_timestamp_ranges(raw_string)
    return [] if raw_string[2..-3].blank?
    raw_string[2..-3].split("),[").map do |t|
      s,e = t.split(",").map(&:to_i)
      s..(e-1)
    end
  end

  def to_postgres_string
    pg_ranges = @range.ranges.map do |range|
      "[#{range.begin},#{range.end+1})"
    end.pg(',')

    "{#{pg_ranges}}"
  end
end
