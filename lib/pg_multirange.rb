require "active_support"
require "multi_range"

module PgMultirange
  autoload :Base, "pg_multirange/base"
end

# As discussed in https://github.com/rails/rails/issues/40687, this
# patch registers a few types to silence warnings when Rails comes
# across some PostgreSQL types it does not recognize.
module PostgreSQLAdapterMultirangeTypes
  def initialize_type_map(m = type_map)
    m.register_type('int4multirange', ActiveRecord::Type::String.new)
    m.register_type('int8multirange', ActiveRecord::Type::String.new)
    m.register_type('nummultirange', ActiveRecord::Type::String.new)
    m.register_type('datemultirange', ActiveRecord::Type::String.new)
    m.register_type('tsmultirange', ActiveRecord::Type::String.new)
    m.register_type('tstzmultirange', ActiveRecord::Type::String.new)

    super
  end
end


ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.include PgMultirange::Base

  # Requires PG adapter right now to suppress errors
  unless defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
    require 'active_record/connection_adapters/postgresql_adapter'
  end
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(
    PostgreSQLAdapterMultirangeTypes
  )
end
