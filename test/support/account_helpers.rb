def sign_up_account attributes
  response = post("/api/account", {
    data: {
      type: "accounts",
      attributes: attributes,
    }
  })
  response.code.must_equal 201
end

def sign_up_and_authorize_account attributes
  sign_up_account attributes

  response = post("/api/auth", {
    data: {
      type: "auth",
      attributes: attributes.dup.tap { |a| a.delete("name") }
    }
  })

  response.code.must_equal 200
  response.json_body.fetch("data").fetch("attributes").fetch("token")
end

