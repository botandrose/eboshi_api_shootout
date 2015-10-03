require "minitest/autorun"
require_relative "../test_helper"

describe "auth API" do
  before do
    db.clean
  end

  describe "POST /api/account" do
    before do
      skip_if_impl_in %w(elixir_phoenix node_express node_hapi ruby_sinatra)
    end

    it "registers a new user account" do
      response = post("/api/account", {
        "data" => [{
          "type" => "accounts",
          "attributes" => {
            "name" => "Micah Geisel",
            "email" => "micah@botandrose.com",
            "password" => "omgponies",
          }
        }]
      })

      # we can't stub time, so pull out timestamps and assert on format :(
      json_body = response.json_body
      created_at = json_body["data"][0]["attributes"].delete("created_at")
      updated_at = json_body["data"][0]["attributes"].delete("updated_at")
      created_at.must_match /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\Z/
      updated_at.must_match /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\Z/

      json_body.must_equal({
        "data" => [{
          "type" => "accounts",
          "id" => "1",
          "attributes" => {
            "name" => "Micah Geisel",
            "email" => "micah@botandrose.com",
          },
        }]
      })
      response.code.must_equal 201

      response = post("/api/auth", {
        "data" => [{
          "type" => "auth",
          "attributes" => {
            "email" => "micah@botandrose.com",
            "password" => "badpassword",
          },
        }]
      })
      response.json_body.must_equal({
        "errors" => [{
          "title" => "Invalid authentication credentials",
        }]
      })
      response.code.must_equal 403

      response = post("/api/auth", {
        "data" => [{
          "type" => "auth",
          "attributes" => {
            "email" => "micah@botandrose.com",
            "password" => "omgponies",
          },
        }]
      })

      # don't want test to mandate secret key, so pull out token and validate JWT format
      json_body = response.json_body
      token = json_body["data"][0]["attributes"].delete("token")
      token.must_match /\A\w+\.\w+\.\w+\Z/
      json_body.must_equal({
        "data" => [{
          "type" => "auth",
          "attributes" => {
            "email" => "micah@botandrose.com",
          },
        }]
      })
      response.code.must_equal 200

      response = get("/api/greet", "Authorization" => "Bearer xyz.789")
      response.code.must_equal 403
      response.json_body.must_equal({
        "errors" => [{
          "title" => "Invalid authentication token",
        }]
      })

      response = get("/api/greet", "Authorization" => "Bearer #{token}")
      response.code.must_equal 200
      response.body.must_equal "Hello, Micah Geisel!"
    end
  end
end
