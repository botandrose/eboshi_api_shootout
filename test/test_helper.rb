Dir["./test/support/*.rb"].each { |file| require file }

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
