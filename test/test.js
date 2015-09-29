var supertest = require('supertest');

var request = function (path) {
    return supertest('http://localhost:6969')
    .get(path)
    .expect(200);
}

describe('/api/test', function() {
    it('returns "Hello world"', function (done) {
        request('/api/test').expect('Hello world', done);
    });
});
