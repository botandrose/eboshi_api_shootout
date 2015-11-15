require "minitest/autorun"
require_relative "../test_helper"

describe "line items API" do
  describe "GET /api/clients/:client_id/line_items" do
    before do
      skip_if_impl_in %w(clojure_liberator crystal_kemal elixir_phoenix haskell_scotty kotlin_spark node_express node_hapi python_flask ruby_sinatra)

      db.seed(<<-SQL)
        INSERT INTO line_items SET
          id=1,
          client_id=1,
          user_id=1,
          start="2000-01-01T00:00:00Z",
          finish="2000-01-01T02:30:00Z",
          rate=100.00,
          notes="Unassigned line item",
          created_at="2000-01-01T00:00:00Z",
          updated_at="2000-01-01T02:30:00Z",
          invoice_id=NULL,
          type="LineItem";
      SQL

      @token = sign_up_and_authorize_account({
        name: "Micah Geisel",
        email: "micah@botandrose.com",
        password: "omgponies",
      })
    end

    it "lists line items for the given client" do
      response = get("/api/clients/1/line_items", "Authorization" => "Bearer #{@token}")
      response.json_body.must_equal_json({
        data: [{
          type: "line_items",
          id: "1",
          attributes: {
            client_id: "1",
            user_id: "1",
            start: "2000-01-01T00:00:00Z",
            finish: "2000-01-01T02:30:00Z",
            hours: 2.5,
            rate: 100.00,
            total: 250.00,
            notes: "Unassigned line item",
            created_at: "2000-01-01T00:00:00Z",
            updated_at: "2000-01-01T02:30:00Z",
            invoice_id: nil,
            type: "LineItem",
          }
        }]
      })
    end
  end
end

