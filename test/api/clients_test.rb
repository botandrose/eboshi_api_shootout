require "minitest/autorun"
require_relative "../test_helper"

describe "clients resource API" do
  before do
    db.clean
  end

  describe "GET /api/clients" do
    before do
      skip_if_impl_in %w(node_express kotlin_spark)

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
          created_at="2006-06-25T14:08:31",
          updated_at="2015-08-29T09:58:23";
      SQL
    end

    it "returns a json list of clients" do
      response = get("/api/clients")
      response.json_body.must_equal_json({
        data: [{
          type: "clients",
          id: "1",
          attributes: {
            name: "Bot and Rose Design",
            address: "625 NW Everett St",
            city: "Portland",
            state: "OR",
            zip: "97209",
            country: "USA",
            email: "info@botandrose.com",
            contact: "Michael Gubitosa",
            phone: "(503) 662-2712",
            created_at: "2006-06-25T14:08:31Z",
            updated_at: "2015-08-29T09:58:23Z",
          },
        }]
      })
      response.code.must_equal 200
    end
  end

  describe "POST /api/clients" do
    before do
      skip_if_impl_in %w(node_express ruby_sinatra kotlin_spark)
    end

    it "persists the supplied json list of clients, and returns the result" do
      response = post("/api/clients", {
        data: {
          type: "clients",
          attributes: {
            name: "Bot and Rose Design",
            address: "625 NW Everett St",
            city: "Portland",
            state: "OR",
            zip: "97209",
            country: "USA",
            email: "info@botandrose.com",
            contact: "Michael Gubitosa",
            phone: "(503) 662-2712",
            created_at: "2006-06-25T14:08:31Z",
            updated_at: "2015-08-29T09:58:23Z",
          }
        }
      })
      response.json_body.must_equal_json({
        data: {
          type: "clients",
          id: "1",
          attributes: {
            name: "Bot and Rose Design",
            address: "625 NW Everett St",
            city: "Portland",
            state: "OR",
            zip: "97209",
            country: "USA",
            email: "info@botandrose.com",
            contact: "Michael Gubitosa",
            phone: "(503) 662-2712",
            created_at: "2006-06-25T14:08:31Z",
            updated_at: "2015-08-29T09:58:23Z",
          }
        }
      })
      response.code.must_equal 201

      response = get("/api/clients")
      response.json_body.must_equal_json({
        data: [{
          type: "clients",
          id: "1",
          attributes: {
            name: "Bot and Rose Design",
            address: "625 NW Everett St",
            city: "Portland",
            state: "OR",
            zip: "97209",
            country: "USA",
            email: "info@botandrose.com",
            contact: "Michael Gubitosa",
            phone: "(503) 662-2712",
            created_at: "2006-06-25T14:08:31Z",
            updated_at: "2015-08-29T09:58:23Z",
          },
        }]
      })
      response.code.must_equal 200
    end
  end

  describe "DELETE /api/clients/:id" do
    before do
      skip_if_impl_in %w(node_express ruby_sinatra kotlin_spark)

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
          created_at="2006-06-25T14:08:31",
          updated_at="2015-08-29T09:58:23";
      SQL
    end

    it "deletes the specified client" do
      response = delete("/api/clients/1")
      response.code.must_equal 204

      response = get("/api/clients")
      response.json_body.must_equal_json({ data: [] })
    end
  end
end
