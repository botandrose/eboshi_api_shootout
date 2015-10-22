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
    set_password
    system "mysql -u'#{username}' #{database} -e'#{statement}'"
  end

  def create_database
    set_password
    statement = "CREATE DATABASE IF NOT EXISTS `#{database}`;"
    system "mysql -u'#{username}' -e'#{statement}'"
  end

  def username
    ENV["EBOSHI_API_SHOOTOUT_MYSQL_USERNAME"] || "root"
  end

  def set_password
    ENV["MYSQL_PWD"] = ENV["EBOSHI_API_SHOOTOUT_MYSQL_PASSWORD"]
  end

  def database
    ENV["EBOSHI_API_SHOOTOUT_MYSQL_DATABASE"] || "eboshi_test"
  end
end


