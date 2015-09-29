var supertest = require('supertest');
var mysql     = require('mysql');

var request = function (path) {
    return supertest('http://localhost:6969')
    .get(path)
    .expect(200);
}

var connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
});
connection.connect();

describe.skipIfImpl = function(impls, title, fn) {
  var currentImpl = process.env["EBOSHI_API_SHOOTOUT_CURRENT_IMPL"];
  if(impls.indexOf(currentImpl) !== -1) {
      return this.skip(title, fn);
  } else {
      return this(title, fn);
  };
};

describe('/api/test', function() {
    it('returns "Hello world"', function (done) {
        request('/api/test').expect('Hello world', done);
    });
});

describe.skipIfImpl(['./elixir_phoenix', './node_express', './ruby_rack', './ruby_sinatra'], '/api/clients', function() {
    before(function(done) {
        connection.query("CREATE DATABASE IF NOT EXISTS `eboshi_test`;", function() {
            connection.database = 'eboshi_test';
            done();
        });
    });

    before(function(done) {
        connection.query("DROP TABLE IF EXISTS `clients`;", function() { done(); });
    });

    before(function(done) {
        connection.query(
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
            function() { done(); });
    });

    before(function(done) {
        connection.query(
            "INSERT INTO clients SET " +
            "  name='Bot and Rose Design', " +
            "  address='625 NW Everett St', " +
            "  city='Portland', " +
            "  state='OR', " +
            "  zip='97209', " +
            "  country='USA', " +
            "  email='info@botandrose.com', " +
            "  contact='Michael Gubitosa', " +
            "  phone='(503) 662-2712', " +
            "  created_at='2006-06-25T14:08:31Z', " +
            "  updated_at='2015-08-29T09:58:23Z';",
            function(err) { if(err) throw err; done(); }
        );
    });

    it('returns a json list of clients', function (done) {
        request('/api/clients').expect({
            "data": [{
                "type": "clients",
                "id": "1",
                "attributes": {
                    "name": "Bot and Rose Design",
                    "address": "625 NW Everett St",
                    "city": "Portland",
                    "state": "OR",
                    "zip": "97209",
                    "country": "USA",
                    "email": "info@botandrose.com",
                    "contact": "Michael Gubitosa",
                    "phone": "(503) 662-2712",
                    "created_at": "2006-06-25T14:08:31Z",
                    "updated_at": "2015-08-29T09:58:23Z",
                },
            }]
        }, done);
    });
});

