var mysql = require('mysql');

module.exports = {
    bootstrap: function(done) {
        var username = process.env['EBOSHI_API_SHOOTOUT_MYSQL_USERNAME'] || 'root';
        var password = process.env['EBOSHI_API_SHOOTOUT_MYSQL_PASSWORD'] || '';
        var database = process.env['EBOSHI_API_SHOOTOUT_MYSQL_DATABASE'] || 'eboshi_test';

        this.connection = mysql.createConnection({
            host: 'localhost',
            user: username,
            password: password,
        });

        var self = this;

        this.query("CREATE DATABASE IF NOT EXISTS `" + database + "`;", function(err) {
            if(err) throw err;

            self.query("USE `" + database + "`;", function(err) {
                if(err) throw err;

                self.query("DROP TABLE IF EXISTS `clients`;", function(err) {
                    if(err) throw err;
                    self.query(
                        "CREATE TABLE `clients` (" +
                        "  `id` int(11) NOT NULL AUTO_INCREMENT," +
                        "  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL," +
                        "  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL," +
                        "  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL," +
                        "  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL," +
                        "  `zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL," +
                        "  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL," +
                        "  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL," +
                        "  `contact` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL," +
                        "  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL," +
                        "  `created_at` datetime DEFAULT NULL," +
                        "  `updated_at` datetime DEFAULT NULL," +
                        "  PRIMARY KEY (`id`)" +
                        ") ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;",
                        function(err, res) { if(err) throw err; done(); });
                  });
            });
        });
    },

    query: function() {
        this.connection.query.apply(this.connection, arguments);
    },
};
