class DB
  def seed sql
    clean
    query sql
  end

  def bootstrap
    create_database
    clean
  end

  def clean
    schema_path = File.expand_path("../schema.sql", __FILE__)
    query(File.read(schema_path))
  end

  private

  def query statement
    process_password
    system "mysql -u'#{username}' #{database} -e'#{statement}'"
  end

  def create_database
    process_password
    statement = "CREATE DATABASE IF NOT EXISTS `#{database}`;"
    system "mysql -u'#{username}' -e'#{statement}'"
  end

  def username
    ENV["EBOSHI_API_SHOOTOUT_MYSQL_USERNAME"] || "root"
  end

  def process_password
    if ENV["EBOSHI_API_SHOOTOUT_MYSQL_PASSWORD"] then
      ENV["MYSQL_PWD"] = ENV["EBOSHI_API_SHOOTOUT_MYSQL_PASSWORD"]
    end
  end

  def database
    ENV["EBOSHI_API_SHOOTOUT_MYSQL_DATABASE"] || "eboshi_test"
  end
end


