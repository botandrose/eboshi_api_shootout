require 'bundler/setup'
require 'sinatra'
require 'mysql2'
require 'json'
require 'jwt'
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
  "Hello world"
end

get '/api/clients/:client_id/line_items' do
  content_type :json
  line_items = db.query("SELECT * FROM line_items WHERE client_id=#{params[:client_id]}")
  line_items_data = line_items.map do |line_item|
    line_item['user_id'] = line_item['user_id'].to_s
    line_item['client_id'] = line_item['client_id'].to_s
    line_item['rate'] = line_item['rate'].to_f
    line_item['hours'] = (line_item['finish'] - line_item['start']) / 60 / 60
    line_item['total'] = line_item['hours'] * line_item['rate']

    line_item['start'] = line_item['start'].iso8601
    line_item['finish'] = line_item['finish'].iso8601
    line_item['created_at'] = line_item['created_at'].iso8601
    line_item['updated_at'] = line_item['updated_at'].iso8601
    {
      type: 'line_items',
      id: line_item.delete('id').to_s,
      attributes: line_item,
    }
  end
  { data: line_items_data }.to_json
end

patch '/api/clients/:client_id/clock_in' do
  content_type :json

  payload = JSON.load(request.body.read)
  token = (request.env["HTTP_AUTHORIZATION"] || "")[/^Bearer (.+)$/, 1]
  decoded_token = JWT.decode token, "omgponies"
  user = User.find(decoded_token.first["id"])
  current_user_id = user.id

  now = Time.now
  rate = payload["data"]["attributes"]["rate"]
  payload = JSON.load(request.body.read)
  notes = payload["data"]["attributes"]["notes"]

  db.query(<<-SQL)
  INSERT INTO line_items SET
    client_id=#{params[:client_id]},
    user_id=#{current_user_id},
    start='#{now}',
    rate=#{rate},
    notes='#{notes}',
    created_at='#{now}',
    updated_at='#{now}',
    type='LineItem';
  SQL

  line_items = db.query("SELECT * FROM line_items ORDER BY id DESC LIMIT 1")
  line_items = line_items.map do |line_item|
    line_item['user_id'] = line_item['user_id'].to_s
    line_item['client_id'] = line_item['client_id'].to_s
    line_item['rate'] = line_item['rate'].to_f
    line_item['start'] = line_item['start'].iso8601
    line_item['created_at'] = line_item['created_at'].iso8601
    line_item['updated_at'] = line_item['updated_at'].iso8601
    {
      type: 'line_items',
      id: line_item.delete('id').to_s,
      attributes: line_item,
    }
  end
  { data: line_items.first }.to_json
end

patch '/api/clients/:client_id/clock_out' do
  token = (request.env["HTTP_AUTHORIZATION"] || "")[/^Bearer (.+)$/, 1]
  decoded_token = JWT.decode token, "omgponies"
  user = User.find(decoded_token.first["id"])
  current_user_id = user.id

  payload = JSON.load(request.body.read)
  notes = payload["data"]["attributes"]["notes"]
  now = Time.now

  db.query(<<-SQL)
  UPDATE line_items SET
    notes='#{notes}',
    finish='#{now}',
    updated_at='#{now}'
  WHERE
    client_id=#{params[:client_id]} AND
    user_id=#{current_user_id} AND
    finish IS NULL;
  SQL

  line_items = db.query("SELECT * FROM line_items ORDER BY id DESC LIMIT 1")
  line_items = line_items.map do |line_item|
    line_item['user_id'] = line_item['user_id'].to_s
    line_item['client_id'] = line_item['client_id'].to_s
    line_item['rate'] = line_item['rate'].to_f
    line_item['hours'] = (line_item['finish'] - line_item['start']) / 60 / 60
    line_item['total'] = line_item['hours'] * line_item['rate']

    line_item['start'] = line_item['start'].iso8601
    line_item['finish'] = line_item['finish'].iso8601
    line_item['created_at'] = line_item['created_at'].iso8601
    line_item['updated_at'] = line_item['updated_at'].iso8601
    {
      type: 'line_items',
      id: line_item.delete('id').to_s,
      attributes: line_item,
    }
  end
  { data: line_items.first }.to_json
end

get '/api/greet' do
  begin
    token = (request.env["HTTP_AUTHORIZATION"] || "")[/^Bearer (.+)$/, 1]
    decoded_token = JWT.decode token, "omgponies"
    user = User.find(decoded_token.first["id"])
    "Hello, #{user.name}!"
  rescue JWT::DecodeError
    status 403
    { "errors" => [{
      "title" => "Invalid authentication token",
    }] }.to_json
  end
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

post '/api/account' do
  payload = JSON.load(request.body.read)
  user_attrs = payload["data"]["attributes"]
  password = user_attrs.delete("password")
  salt = SecureRandom.hex(127)
  query = user_attrs.map do |key, value|
    "`#{key}`='#{value}'"
  end.join(', ')
  crypted_password = Encrypter.encrypt(password, salt)
  query += ", crypted_password='#{crypted_password}'"
  query += ", password_salt='#{salt}'"
  query += ", created_at=NOW()"
  query += ", updated_at=NOW()"
  db.query("INSERT INTO users SET #{query};")
  ids = [db.last_id]

  users = db.query("SELECT * FROM users WHERE id in (#{ids.join(", ")})")

  user_data = users.map do |user|
    user['created_at'] = user['created_at'].iso8601
    user['updated_at'] = user['updated_at'].iso8601
    user.delete("crypted_password")
    user.delete("password_salt").inspect
    {
      type: "accounts",
      id: user.delete('id').to_s,
      attributes: user,
    }
  end

  status 201
  { data: user_data }.to_json
end

post '/api/auth' do
  payload = JSON.load(request.body.read)
  auth = Auth.new(payload["data"]["attributes"])
  if auth.valid?
    status 200
    { data: {
      type: "auth",
      attributes: {
        email: auth.email,
        token: auth.token,
      },
    }}.to_json
  else
    status 403
    { errors: [
      { title: "Invalid authentication credentials" },
    ]}.to_json
  end
end

class Auth < Struct.new(:attributes)
  SECRET = "omgponies"

  def valid?
    user.crypted_password == Encrypter.encrypt(password, user.password_salt)
  end

  def email
    attributes["email"]
  end

  def password
    attributes["password"]
  end

  def user
    @user ||= User.find_by_email(email)
  end

  def token
    payload = { id: user.id }
    JWT.encode(payload, SECRET, 'HS256')
  end
end

class Encrypter
  def self.encrypt *tokens
    new.encrypt *tokens
  end

  def encrypt *tokens
    digest = tokens.flatten.join(join_token)
    stretches.times { digest = Digest::SHA512.hexdigest(digest) }
    digest
  end

  def stretches
    20
  end

  def join_token
    nil
  end
end

class User < OpenStruct
  def self.find_by_email email
    query = "SELECT * FROM users WHERE email='#{email}' LIMIT 1"
    attrs = db.query(query).first
    new(attrs)
  end

  def self.find id
    query = "SELECT * FROM users WHERE id='#{id}' LIMIT 1"
    attrs = db.query(query).first
    new(attrs)
  end
end
