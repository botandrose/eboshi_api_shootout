require "mysql"

class DBModel
  def self.connection
    @@connection ||= MySQL.connect("127.0.0.1", "root", "", "eboshi_test", 3306_u16, nil)
  end

  def self.all
    connection.query("SELECT * FROM #{table_name}").not_nil!.map do |row|
      attributes = {} of Symbol => MySQL::Types::SqlType
      row.not_nil!.size.times do |index|
        attributes[fields[index]] = row[index]
      end
      new attributes
    end
  end

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

  def as_json_api_hash
    attributes = {} of Symbol => String
    self.class.fields.each do |field|
      next if field == :id
      value = @attributes[field]
      if value.is_a? Time
        attributes[field] = value.to_s("%FT%TZ")
      else
        attributes[field] = value.to_s
      end
    end

    {
      type: self.class.table_name,
      id: id.to_s,
      attributes: attributes,
    }
  end
end

