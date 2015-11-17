module DBModel
  module DBAccess
    def connection
      @@connection ||= MySQL.connect("127.0.0.1", "root", "", "eboshi_test", 3306_u16, nil)
    end

    def all
      results = connection.query("SELECT * FROM #{table_name}")
      materialize_results(results)
    end

    def find id
      results = connection.query("SELECT * FROM #{table_name} WHERE id=#{id}")
      materialize_results(results).first
    end

    private def materialize_results results
      results.not_nil!.map do |row|
        attributes = {} of String => MySQL::Types::SqlType
        row.not_nil!.size.times do |index|
          attributes[fields[index]] = row[index]
        end
        new attributes
      end
    end
  end
end

