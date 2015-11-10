require "kemal"

Kemal.config.port = 6969

get "/api/test" do
  "Hello world"
end
