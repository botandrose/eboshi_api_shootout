require "minitest/autorun"
require_relative "../test_helper"

describe "auth API" do
  before do
    db.clean
  end

  describe "POST /api/account, POST /api/auth, GET /api/greet" do
    before do
      skip_if_impl_in %w(elixir_phoenix haskell_scotty node_express node_hapi python_flask ruby_sinatra)
    end

    it "signs up for an account, logs in to receive auth token, uses auth token to verify identity" do
      response = post("/api/account", {
        data: {
          type: "accounts",
          attributes: {
            name: "Micah Geisel",
            email: "micah@botandrose.com",
            password: "omgponies",
          }
        }
      })

      # we can't stub time, so pull out timestamps and assert on format :(
      json_body = response.json_body
      created_at = json_body["data"]["attributes"].delete("created_at")
      updated_at = json_body["data"]["attributes"].delete("updated_at")
      created_at.must_match /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\Z/
      updated_at.must_match /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\Z/

      json_body.must_equal_json({
        data: {
          type: "accounts",
          id: "1",
          attributes: {
            name: "Micah Geisel",
            email: "micah@botandrose.com",
          },
        }
      })
      response.code.must_equal 201

      response = post("/api/auth", {
        data: {
          type: "auth",
          attributes: {
            email: "micah@botandrose.com",
            password: "badpassword",
          },
        }
      })
      response.json_body.must_equal_json({
        errors: [{
          title: "Invalid authentication credentials",
        }]
      })
      response.code.must_equal 401

      response = post("/api/auth", {
        data: {
          type: "auth",
          attributes: {
            email: "micah@botandrose.com",
            password: "omgponies",
          },
        }
      })

      # don't want test to mandate secret key, so pull out token and validate JWT format
      json_body = response.json_body
      token = json_body["data"]["attributes"].delete("token")
      token.must_match /\A\w+\.\w+\.\w+\Z/
      json_body.must_equal_json({
        data: {
          type: "auth",
          attributes: {
            email: "micah@botandrose.com",
          },
        }
      })
      response.code.must_equal 200

      response = get("/api/greet", "Authorization" => "Bearer xyz.789")
      response.code.must_equal 401
      response.json_body.must_equal_json({
        errors: [{
          title: "Invalid authentication token",
        }]
      })

      response = get("/api/greet", "Authorization" => "Bearer #{token}")
      response.code.must_equal 200
      response.body.must_equal "Hello, Micah Geisel!"
    end
  end
end
