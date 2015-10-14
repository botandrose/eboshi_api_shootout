from flask import Flask, request, jsonify
from models.clients import db, Client

app = Flask(__name__)
app.config.from_pyfile('hello.cfg')
db.init_app(app)

@app.route("/api/test")
def hello():
    return "Hello world"

@app.route('/api/clients', methods = ['GET', 'POST'])
def clients():
    if request.method == 'POST':
        attributes = request.get_json(force=True)['data']['attributes']
        new_client = Client(attributes)
        db.session.add(new_client)
        db.session.commit()
        return jsonify(data = new_client.as_dict), 201

    data = Client.query.all()
    result = [d.as_dict for d in data]
    return jsonify(data = result)

@app.route('/api/clients/<id>', methods = ['DELETE'])
def delete_client(id):
    if request.method == 'DELETE':
        target_client = Client.query.filter_by(id = id).first()
        db.session.delete(target_client)
        db.session.commit()
        return jsonify(data = []), 204
