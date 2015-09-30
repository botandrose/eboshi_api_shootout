require "net/http"
require "json"
require_relative "./db"

def db
  $db ||= DB.new.tap(&:bootstrap)
end

def skip_if_impl_in impls
  before do
    skip if impls.include?(ENV["EBOSHI_API_SHOOTOUT_CURRENT_IMPL"])
  end
end

def seed sql
  before { db.seed sql }
end

def request url
  uri = URI("http://localhost:6969#{url}")
  response = Net::HTTP.get(uri)
  JSON.load(response)
end

