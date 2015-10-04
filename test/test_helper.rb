require_relative "./db"
require_relative "./http"

def db
  $db ||= DB.new.tap(&:bootstrap)
end

def skip_if_impl_in impls
  skip if impls.include?(ENV["EBOSHI_API_SHOOTOUT_CURRENT_IMPL"])
end

def get *args
  Request.get(*args)
end

def post *args
  Request.post(*args)
end

def delete *args
  Request.delete(*args)
end
