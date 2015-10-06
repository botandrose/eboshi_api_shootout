from flask import Flask
from flask.ext.mysql import MySQL

app = Flask(__name__)
mysql = MySQL(app)

# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = ''
app.config['MYSQL_DATABASE_DB'] = 'eboshi_test'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)

@app.route("/api/test")
def hello():
    return "Hello World!"

@app.route('/api/clients')
def users():
    cursor = mysql.connection.cursor()
    cursor.execute('''SELECT * FROM clients''')
    clients = cursor.fetchall()
    return jsonify(clients)

if __name__ == "__main__":
    app.debug = True
    app.run(port=6969)