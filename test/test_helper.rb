require "net/http"
require "json"
require_relative "./db"

def db
  $db ||= DB.new.tap(&:bootstrap)
end

def skip_if_impl_in impls
  skip if impls.include?(ENV["EBOSHI_API_SHOOTOUT_CURRENT_IMPL"])
end

def get url
  request :get, url
end

def post url, data
  request :post, url, data
end

def request method, url, data=nil
  response = Net::HTTP.new("localhost", 6969).start do |http|
    request = Net::HTTP.const_get(method.to_s.capitalize).new(url, initheader = {'Content-Type' =>'application/json'})
    request.body = JSON.dump(data) if data
    http.request(request)
  end
  JSON.load(response.body)
rescue JSON::ParserError
  response.body
end

