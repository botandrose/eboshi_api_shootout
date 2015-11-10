require "./db_model"

class Client < DBModel::Base
  self.table_name = "clients"

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
end

