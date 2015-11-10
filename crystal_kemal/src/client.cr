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
      {
        type: "clients",
        id: attributes.delete(:id).to_s,
        attributes: {
          name: attributes[:name].to_s,
          address: attributes[:address].to_s,
          city: attributes[:city].to_s,
          state: attributes[:state].to_s,
          zip: attributes[:zip].to_s,
          country: attributes[:country].to_s,
          email: attributes[:email].to_s,
          contact: attributes[:contact].to_s,
          phone: attributes[:phone].to_s,
          created_at: (attributes[:created_at] as Time).to_s("%FT%TZ"),
          updated_at: (attributes[:updated_at] as Time).to_s("%FT%TZ"),
        }
      }
    end
  end
end

