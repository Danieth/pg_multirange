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
    pg_ranges = @ranges.map do |range|
      if range.exclude_end?
        "[#{range.begin},#{range.end - 1}]"
      else
        "[#{range.begin},#{range.end}]"
      end
    end.join(',')

    "{#{pg_ranges}}"
  end
end
