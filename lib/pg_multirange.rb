# frozen_string_literal: true
require "active_support"
# require_relative "pg_multirange/version"

module PgMultirange
  # class Error < StandardError; end
  autoload :Base, "pg_multirange/base"
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.include PgMultirange::Base
end
