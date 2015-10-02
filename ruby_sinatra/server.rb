require 'bundler/setup'
require 'sinatra'
require 'mysql2'
require 'json'
require 'byebug'

set :port, 6969

def db
  @db ||= Mysql2::Client.new({
    host: 'localhost',
    username: ENV['EBOSHI_API_SHOOTOUT_MYSQL_USERNAME'] || 'root',
    password: ENV['EBOSHI_API_SHOOTOUT_MYSQL_PASSWORD'] || '',
    database: ENV['EBOSHI_API_SHOOTOUT_MYSQL_DATABASE'] || 'eboshi_test',
    database_timezone: :utc,
  })
end

configure do
  set :raise_errors, true
  set :show_exceptions, false
end

get '/api/test' do
  'Hello world'
end

get '/api/clients' do
  content_type :json

  clients = db.query('SELECT * FROM clients')

  client_data = clients.map do |client|
    client['created_at'] = client['created_at'].iso8601
    client['updated_at'] = client['updated_at'].iso8601
    {
      type: 'clients',
      id: client.delete('id').to_s,
      attributes: client,
    }
  end

  { data: client_data }.to_json
end

post '/api/clients' do
  content_type :json

  payload = JSON.load(request.body.read)
  ids = payload["data"].map do |clients_attrs|
    query = clients_attrs["attributes"].map do |key, value|
      "`#{key}`='#{value}'"
    end.join(', ')
    db.query("INSERT INTO clients SET #{query};")
    db.last_id
  end

  query = "SELECT * FROM clients WHERE id IN (#{ids.join(',')})"
  clients = db.query(query)

  client_data = clients.map do |client|
    client['created_at'] = client['created_at'].iso8601
    client['updated_at'] = client['updated_at'].iso8601
    {
      type: 'clients',
      id: client.delete('id').to_s,
      attributes: client,
    }
  end

  { data: client_data }.to_json
end
