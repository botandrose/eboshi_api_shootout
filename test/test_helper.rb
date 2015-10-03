require_relative "./db"
require_relative "./http"

def db
  $db ||= DB.new.tap(&:bootstrap)
end

def skip_if_impl_in impls
  skip if impls.include?(ENV["EBOSHI_API_SHOOTOUT_CURRENT_IMPL"])
end

def get url, headers={}
  Request.get(url, headers)
end

def post url, data, headers={}
  Request.post(url, data, headers)
end

def delete url, headers={}
  Request.delete(url, headers)
end
