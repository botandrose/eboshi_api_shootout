class Object
  def must_equal_json hash
    must_equal JSON[hash.to_json]
  end
end
