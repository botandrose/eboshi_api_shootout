from flask import Flask, jsonify
from models.clients import db, Client

app = Flask(__name__)
app.config.from_pyfile('hello.cfg')
db.init_app(app)

@app.route("/api/test")
def hello():
    return "Hello world"

@app.route('/api/clients')
def clients():
    data = Client.query.all()
    result = [d.as_dict for d in data]
    return jsonify(data = result)
