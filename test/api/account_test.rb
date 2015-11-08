require "minitest/autorun"
require_relative "../test_helper"

describe "account API" do
  before do
    db.clean
  end

  ISO_8601_PATTERN = /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\Z/

  describe "POST /api/account" do
    before do
      skip_if_impl_in %w(clojure_liberator crystal_kemal elixir_phoenix node_express node_hapi python_flask ruby_sinatra)
    end

    it "signs up for an account" do
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

      response.json_body.must_equal_json({
        data: {
          type: "accounts",
          id: "1",
          attributes: {
            name: "Micah Geisel",
            email: "micah@botandrose.com",
            created_at: ISO_8601_PATTERN,
            updated_at: ISO_8601_PATTERN,
          },
        }
      })
      response.code.must_equal 201
    end
  end

  describe "GET /api/account" do
    before do
      skip_if_impl_in %w(crystal_kemal elixir_phoenix haskell_scotty node_express node_hapi python_flask ruby_sinatra clojure_liberator)

      @token = sign_up_and_authorize_account({
        name: "Micah Geisel",
        email: "micah@botandrose.com",
        password: "omgponies",
      })
    end

    it "uses auth token to verify identity" do
      response = get("/api/account", "Authorization" => "Bearer #{@token}")
      response.json_body.must_equal_json({
        data: {
          type: "accounts",
          id: "1",
          attributes: {
            name: "Micah Geisel",
            email: "micah@botandrose.com",
            created_at: ISO_8601_PATTERN,
            updated_at: ISO_8601_PATTERN,
          },
        }
      })
      response.code.must_equal 200
    end

    it "rejects bad Authorization header" do
      response = get("/api/account", "Authorization" => "Bearer xyz.789")
      response.json_body.must_equal_json({
        errors: [{
          title: "Invalid authentication token",
        }]
      })
      response.code.must_equal 401
    end
  end
end

