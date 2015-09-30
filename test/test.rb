require "minitest/autorun"
require_relative "./test_helper"

describe "api" do
  describe "/api/clients" do
    before do
      skip_if_impl_in %w(./elixir_phoenix ./node_express ./ruby_sinatra)
    end

    before do
      db.seed(<<-SQL)
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
          created_at="2006-06-25T14:08:31Z",
          updated_at="2015-08-29T09:58:23Z";
      SQL
    end

    it "returns a json list of clients" do
      request("/api/clients").must_equal({
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
