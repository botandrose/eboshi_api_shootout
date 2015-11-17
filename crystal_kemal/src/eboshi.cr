require "kemal"
require "json"
require "./client"

Kemal.config.port = 6969

get "/api/test" do
  "Hello world"
end

get "/api/clients" do
  { data: Client.all.map(&.serialize) }.to_json
end

post "/api/clients" do |env|
  data = env.params["data"] as Hash
  attributes = data["attributes"] as Hash
  client = Client.create(attributes)

  env.status_code = 201
  { data: client.serialize }.to_json
end

Signal::INT.trap { exit }

