var request = require('supertest');

describe('/api/test', function() {

    it('should return Hello world', function (done) {
        request('http://localhost:6969')
        .get('/api/test')
        .expect(200)
        .expect('Hello world', done);
    });

});
