require "json"

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
    query(<<-SQL)
      DROP TABLE IF EXISTS `clients`;
      CREATE TABLE `clients` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `contact` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `created_at` datetime DEFAULT NULL,
        `updated_at` datetime DEFAULT NULL,
        PRIMARY KEY (`id`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
    SQL
  end

  def query statement
    system "mysql -u'#{username}' #{database} -e'#{statement}'"
  end

  def create_database
    statement = "CREATE DATABASE IF NOT EXISTS `#{database}`;"
    system "mysql -u'#{username}' -e'#{statement}'"
  end
end


