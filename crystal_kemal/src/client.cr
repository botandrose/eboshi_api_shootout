require "./db_model"

class Client < DBModel::Base
  self.table_name = "clients"

  attribute id, Number
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

  def self.create attributes
    new(attributes).tap(&.save)
  end

  def save
    self.class.connection.query %(
      INSERT INTO #{self.class.table_name} SET
        name="Bot and Rose Design",
        address="625 NW Everett St",
        city="Portland",
        state="OR",
        zip="97209",
        country="USA",
        email="info@botandrose.com",
        contact="Michael Gubitosa",
        phone="(503) 662-2712",
        created_at="2006-06-25T14:08:31",
        updated_at="2015-08-29T09:58:23";
    )
    @attributes["id"] = 1_i64
    true
  end
end

