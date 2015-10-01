require "minitest/autorun"
require_relative "./test_helper"

describe "api" do
  describe "GET /api/test" do
    it "returns 'hello world'" do
      get("/api/test").must_equal("Hello world")
    end
  end

  describe "GET /api/clients" do
    before do
      skip_if_impl_in %w(node_hapi node_express)

      seed(<<-SQL)
        INSERT INTO clients SET
          name="Bot and Rose Design",
          address="625 NW Everett St",
          city="Portland",
          state="OR",
          zip="97209",
          country="USA",
          email="info@botandrose.com",
          contact="Michael Gubitosa",
          phone="(503) 662-2712",
          created_at="2006-06-25T14:08:31",
          updated_at="2015-08-29T09:58:23";
      SQL
    end

    it "returns a json list of clients" do
      get("/api/clients").must_equal({
        "data" => [{
          "type" => "clients",
          "id" => "1",
          "attributes" => {
            "name" => "Bot and Rose Design",
            "address" => "625 NW Everett St",
            "city" => "Portland",
            "state" => "OR",
            "zip" => "97209",
            "country" => "USA",
            "email" => "info@botandrose.com",
            "contact" => "Michael Gubitosa",
            "phone" => "(503) 662-2712",
            "created_at" => "2006-06-25T14:08:31Z",
            "updated_at" => "2015-08-29T09:58:23Z",
          },
        }]
      })
    end
  end
end
