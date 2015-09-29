require "rack"
require "rack/server"
require "json"
require "mysql2"

class App
  def self.call(env)
    case env["PATH_INFO"]
    when "/api/test" then HelloWorld.new.call
    when "/api/clients" then Clients.new.call
    end
  end

  class HelloWorld
    def call
      [200, {}, ["Hello world"]]
    end
  end

  class Clients
    def call
      [
        200,
       {"Content-type" => "application/json"},
       [{ data: clients }.to_json],
      ]
    end

    private

    def clients
      db.query("SELECT * FROM clients").map do |attributes|
        attributes["created_at"] = attributes["created_at"].iso8601
        attributes["updated_at"] = attributes["updated_at"].iso8601
        {
          type: "clients",
          id: attributes.delete("id").to_s,
          attributes: attributes,
        }
      end
    end

    def db
      @db ||= Mysql2::Client.new({
        host: "localhost",
        username: ENV["EBOSHI_API_SHOOTOUT_MYSQL_USERNAME"] || "root",
        password: ENV["EBOSHI_API_SHOOTOUT_MYSQL_PASSWORD"] || "",
        database: ENV["EBOSHI_API_SHOOTOUT_MYSQL_DATABASE"] || "eboshi_test",
        database_timezone: :utc,
      })
    end
  end
end

Rack::Server.start app: App, Port: 6969
