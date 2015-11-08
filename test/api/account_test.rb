require "minitest/autorun"
require_relative "../test_helper"

describe "account signup API" do
  before do
    db.clean
  end

  describe "POST /api/account" do
    before do
      skip_if_impl_in %w(elixir_phoenix haskell_scotty node_express node_hapi python_flask ruby_sinatra clojure_liberator kotlin_spark)
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

      iso_8601_pattern = /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\Z/

      response.json_body.must_equal_json({
        data: {
          type: "accounts",
          id: "1",
          attributes: {
            name: "Micah Geisel",
            email: "micah@botandrose.com",
            created_at: iso_8601_pattern,
            updated_at: iso_8601_pattern,
          },
        }
      })
      response.code.must_equal 201
    end
  end
end

