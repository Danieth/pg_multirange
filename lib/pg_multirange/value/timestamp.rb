class PgMultirange::Value::Timestamp < PgMultirange::Value

  def attribute_class
    PgMultirange::Attribute::Timestamp
  end

  def convert_postgres_string_to_ranges(raw_string)
    return [] if raw_string[2..-3].blank?
    raw_string[2..-3].split("],[").map do |t|
      s,e = t.split(",").map do |a|
        Time.find_zone("UTC").parse(a).to_time.utc
      end
      s..e
    end
  end

  PG_TIMESTAMP_FORMAT = "%Y-%m-%d %H:%M:%S"
  def to_postgres_string
    @range.ranges.map do |range|
      internal_range = [range.begin, range.end].map do |timestamp|
        formatted = timestamp.strftime(PG_TIMESTAMP_FORMAT)
        "\"#{formatted}\""
      end.join(",")

      "[#{internal_range}]"
    end.join(',')
  end
end
