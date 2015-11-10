require "mysql"

class Client
  def self.connection
    @@connection ||= MySQL.connect("127.0.0.1", "root", "", "eboshi_test", 3306_u16, nil)
  end

  def self.all
    connection.query("SELECT * FROM #{@@table_name}").not_nil!.map do |row|
      attributes = {} of Symbol => MySQL::Types::SqlType
      row.not_nil!.size.times do |index|
        attributes[@@fields[index]] = row[index]
      end
      new attributes
    end
  end

  def initialize attributes
    @attributes = attributes
  end

  @@table_name = "clients"

  @@fields = [] of Symbol

  macro attribute(field, type)
    @@fields.push :{{field}}

    def {{field}}
      @attributes[:{{field}}] as {{type}}
    end
  end

  attribute id, Int32
  attribute name, String
  attribute address, String
  attribute city, String
  attribute state, String
  attribute zip, String
  attribute country, String
  attribute email, String
  attribute contact, String
  attribute phone, String
  attribute created_at, Time
  attribute updated_at, Time

  def as_json_api_hash
    attributes = {} of Symbol => String
    @@fields.each do |field|
      next if field == :id
      value = @attributes[field]
      if value.is_a? Time
        attributes[field] = value.to_s("%FT%TZ")
      else
        attributes[field] = value.to_s
      end
    end

    {
      type: @@table_name,
      id: id.to_s,
      attributes: attributes,
    }
  end
end

