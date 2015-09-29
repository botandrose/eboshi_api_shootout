var supertest = require('supertest');
var db = require('./db');

var request = function (path) {
    return supertest('http://localhost:6969')
    .get(path)
    .expect(200);
}

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
    before(function(done) { db.bootstrap(done); });

    before(function(done) {
        db.query(
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

