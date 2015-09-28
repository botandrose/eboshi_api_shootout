var express = require('express');
var app = express();

app.get('/api/test', function (req, res) {
    res.send('Hello world');
});

var server = app.listen(6969);
