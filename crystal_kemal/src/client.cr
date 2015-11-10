require "mysql"

class Client
  def self.connection
    @@connection ||= MySQL.connect("127.0.0.1", "root", "", "eboshi_test", 3306_u16, nil)
  end

  def self.all
    connection.query("SELECT * FROM clients").not_nil!.map do |row|
      {
        type: "clients",
        id: row.shift.to_s,
        attributes: {
          name: row.shift.to_s,
          address: row.shift.to_s,
          city: row.shift.to_s,
          state: row.shift.to_s,
          zip: row.shift.to_s,
          country: row.shift.to_s,
          email: row.shift.to_s,
          contact: row.shift.to_s,
          phone: row.shift.to_s,
          created_at: (row.shift as Time).to_s("%FT%TZ"),
          updated_at: (row.shift as Time).to_s("%FT%TZ"),
        }
      }
    end
  end
end

