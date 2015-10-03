require "net/http"
require "json"

class Request < Struct.new(:method, :url, :data, :headers)
  def self.get url, headers={}
    new(:get, url, nil, headers).tap(&:call)
  end

  def self.post url, data=nil, headers={}
    new(:post, url, data, headers).tap(&:call)
  end

  def self.delete url, headers={}
    new(:delete, url, nil, headers).tap(&:call)
  end

  attr_accessor :response

  def call
    self.response = Net::HTTP.new("localhost", 6969).start do |http|
      self.headers = { 'Content-Type' => 'application/json' }.merge(headers)
      request = Net::HTTP.const_get(method.to_s.capitalize).new(url, headers)
      request.body = JSON.dump(data) if data
      http.request(request)
    end
  end

  def code
    response.code.to_i
  end

  def body
    response.body
  end

  def json_body
    JSON.load(response.body)
  end
end

