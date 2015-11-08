require "minitest/autorun"
require_relative "../test_helper"

describe "authenticated sections" do
  before do
    db.clean
  end

  describe "GET /api/greet" do
    before do
      skip_if_impl_in %w(elixir_phoenix haskell_scotty node_express node_hapi python_flask ruby_sinatra clojure_liberator kotlin_spark)

      @token = sign_up_and_authorize_account({
        name: "Micah Geisel",
        email: "micah@botandrose.com",
        password: "omgponies",
      })
    end

    it "uses auth token to verify identity" do
      response = get("/api/greet", "Authorization" => "Bearer #{@token}")
      response.body.must_equal "Hello, Micah Geisel!"
      response.code.must_equal 200
    end

    it "rejects bad Authorization header" do
      response = get("/api/greet", "Authorization" => "Bearer xyz.789")
      response.json_body.must_equal_json({
        errors: [{
          title: "Invalid authentication token",
        }]
      })
      response.code.must_equal 401
    end
  end
end
