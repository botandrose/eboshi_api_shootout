module DBModel
  module Serialization
    def serialize
      attributes = {} of String => String
      self.class.fields.each do |field|
        next if field == "id"
        value = @attributes[field]
        if value.is_a? Time
          attributes[field] = value.to_s("%FT%TZ")
        else
          attributes[field] = value.to_s
        end
      end

      {
        "type" => self.class.table_name,
        "id" => id.to_s,
        "attributes" => attributes,
      }
    end
  end
end

