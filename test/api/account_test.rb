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
    end
  end
end

