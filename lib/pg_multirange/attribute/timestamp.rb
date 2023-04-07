class PgMultirange::Attribute::Timestamp < PgMultirange::Attribute

  # '{[2011-01-01,2011-03-01], [2012-01-01,2023-01-01]}'::tsmultirange
  def convert_postgres_range_to_type(_exclude_start, b, e, exclude_end)
    b = Time.find_zone("UTC").parse(b).to_time.utc
    e = Time.find_zone("UTC").parse(e).to_time.utc

    if exclude_end
      b...e
    else
      b..e
    end
  end

  PG_TIMESTAMP_FORMAT = "%Y-%m-%d %H:%M:%S"
  def to_postgres_string
    pg_ranges = @ranges.map do |range|
      internal_range = [range.begin, range.end].map do |timestamp|
        formatted = timestamp.strftime(PG_TIMESTAMP_FORMAT)
        "\"#{formatted}\""
      end.join(",")

      "[#{internal_range}]"
    end.join(',')

    "{#{pg_ranges}}"
  end
end
