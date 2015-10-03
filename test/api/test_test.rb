require "minitest/autorun"
require_relative "../test_helper"

describe "api" do
  describe "GET /api/test" do
    it "returns 'hello world'" do
      response = get("/api/test")
      response.body.must_equal "Hello world"
      response.code.must_equal 200
    end
  end
end

