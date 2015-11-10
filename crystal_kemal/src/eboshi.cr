require "kemal"
require "json"
require "./client"

Kemal.config.port = 6969

get "/api/test" do
  "Hello world"
end

get "/api/clients" do
  { data: Client.all }.to_json
end

Signal::INT.trap { exit }

