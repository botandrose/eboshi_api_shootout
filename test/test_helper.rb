require_relative "./db"
require_relative "./http"

def db
  $db ||= DB.new.tap(&:bootstrap)
end

def skip_if_impl_in impls
  skip if impls.include?(ENV["EBOSHI_API_SHOOTOUT_CURRENT_IMPL"])
end

def get url
  Request.get(url)
end

def post url, data
  Request.post(url, data)
end
