module MustEqualJson
  def self.compare a, b
    case a
    when Hash
      (a.keys + b.keys.map(&:to_s)).uniq.each do |key|
        compare a[key], b[key.to_sym]
      end
    when Array
      [a.length, b.length].max.times do |index|
        compare a[index], b[index]
      end
    when Float, NilClass
      a.must_equal b
    else
      a.must_match b
    end
  end
end

class Object
  def must_equal_json hash
    MustEqualJson.compare self, hash
  end
end

