require 'bundler/setup'
require 'sinatra'
require 'mysql2'
require 'json'

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

get '/api/test' do
  'Hello world'
end

get '/api/clients' do
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
