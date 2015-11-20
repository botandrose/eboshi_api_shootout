Dir["./test/support/*.rb"].each { |file| require file }

ISO_8601_PATTERN = /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\Z/

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

def patch *args
  Request.patch(*args)
end

def delete *args
  Request.delete(*args)
end
