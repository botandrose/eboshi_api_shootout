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
    query = String.build do |str|
      str << "INSERT INTO #{table_name} SET "
      fields_fragment = fields.map do |field|
        next if field == "id"
        %(`#{field}`="#{attributes[field]}")
      end
      fields_fragment.shift
      str << fields_fragment.join(", ")
      str << ";"
    end

    connection.query query
    id = connection.insert_id as UInt64
    find id
  end
end

