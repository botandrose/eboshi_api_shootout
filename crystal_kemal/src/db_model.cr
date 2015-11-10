require "mysql"
require "./db_model/db_access"
require "./db_model/serialization"

class DBModel::Base
  extend DBAccess
  include Serialization

  def initialize attributes
    @attributes = attributes
  end

  def self.fields
    @@fields ||= [] of Symbol
  end

  def self.table_name
    @@table_name
  end

  def self.table_name= value
    @@table_name = value
  end

  macro attribute(field, type)
    fields.push :{{field}}

    def {{field}}
      @attributes[:{{field}}] as {{type}}
    end
  end
end

