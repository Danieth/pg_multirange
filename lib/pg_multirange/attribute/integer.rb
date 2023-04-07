class PgMultirange::Attribute::Integer < PgMultirange::Attribute
  # '{[1,2),[2,6)}'::int4multirange
  def convert_postgres_range_to_type(_exclude_start, b, e, exclude_end)
    b = b.to_i
    e = e.to_i

    if exclude_end
      b...e
    else
      b..e
    end
  end

  def to_postgres_string
    pg_ranges = @range.ranges.map do |range|
      "[#{range.begin},#{range.end+1})"
    end.join(',')

    "{#{pg_ranges}}"
  end
end
