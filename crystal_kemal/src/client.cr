require "mysql"

class Client
  def self.connection
    @@connection ||= MySQL.connect("127.0.0.1", "root", "", "eboshi_test", 3306_u16, nil)
  end

  def self.all
    connection.query("SELECT * FROM clients").not_nil!.map do |row|
      fields = %i(id name address city state zip country email contact phone created_at updated_at)
      attributes = {} of Symbol => (Nil | String | Int32 | Int64 | Float64 | Bool | Time | MySQL::Types::Date)
      row.not_nil!.size.times do |index|
        attributes[fields[index]] = row[index]
      end
      new attributes
    end
  end

  def initialize attributes
    @attributes = attributes
  end

  def id
    @attributes[:id] as Int32
  end

  def name
    @attributes[:name] as String
  end

  def address
    @attributes[:address] as String
  end

  def city
    @attributes[:city] as String
  end

  def state
    @attributes[:state] as String
  end

  def zip
    @attributes[:zip] as String
  end

  def country
    @attributes[:country] as String
  end

  def email
    @attributes[:email] as String
  end

  def contact
    @attributes[:contact] as String
  end

  def phone
    @attributes[:phone] as String
  end

  def created_at
    @attributes[:created_at] as Time
  end

  def updated_at
    @attributes[:updated_at] as Time
  end

  def as_json_api_hash
    {
      type: "clients",
      id: id.to_s,
      attributes: {
        name: name,
        address: address,
        city: city,
        state: state,
        zip: zip,
        country: country,
        email: email,
        contact: contact,
        phone: phone,
        created_at: created_at.to_s("%FT%TZ"),
        updated_at: updated_at.to_s("%FT%TZ"),
      }
    }
  end
end

