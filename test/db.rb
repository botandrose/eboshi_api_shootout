class DB
  def initialize
    bootstrap
  end

  def username
    ENV["EBOSHI_API_SHOOTOUT_MYSQL_USERNAME"] || "root"
  end

  def password
    ENV["EBOSHI_API_SHOOTOUT_MYSQL_PASSWORD"] || ""
  end

  def database
    ENV["EBOSHI_API_SHOOTOUT_MYSQL_DATABASE"] || "eboshi_test"
  end

  def bootstrap
    create_database
    schema_path = File.expand_path("../schema.sql", __FILE__)
    query(File.read(schema_path))
  end

  def query statement
    system "mysql -u'#{username}' #{database} -e'#{statement}'"
  end

  def create_database
    statement = "CREATE DATABASE IF NOT EXISTS `#{database}`;"
    system "mysql -u'#{username}' -e'#{statement}'"
  end
end


