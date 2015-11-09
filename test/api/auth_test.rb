require "minitest/autorun"
require_relative "../test_helper"

describe "auth API" do
  before do
    db.clean
  end

  describe "POST /api/auth" do
    before do
      skip_if_impl_in %w(elixir_phoenix haskell_scotty node_express node_hapi python_flask ruby_sinatra clojure_liberator)

      sign_up_account({
        name: "Micah Geisel",
        email: "micah@botandrose.com",
        password: "omgponies",
      })
    end

    it "logs in to receive auth token" do
      response = post("/api/auth", {
        data: {
          type: "auth",
          attributes: {
            email: "micah@botandrose.com",
            password: "omgponies",
          },
        }
      })

      response.json_body.must_equal_json({
        data: {
          type: "auth",
          attributes: {
            email: "micah@botandrose.com",
            token: /\A(\w|-)+.(\w|-)+.(\w|-)+\Z/,
          },
        }
      })
      response.code.must_equal 200
    end

    it "rejects bad login credentials" do
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
    end
  end
end
