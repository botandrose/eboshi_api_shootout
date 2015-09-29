require "net/http"
require_relative "./db"

$db = DB.new

def skip_if_impl_in impls
  skip if impls.include?(ENV["EBOSHI_API_SHOOTOUT_CURRENT_IMPL"])
end

def request url
  uri = URI("http://localhost:6969#{url}")
  response = Net::HTTP.get(uri)
  JSON.load(response)
end

