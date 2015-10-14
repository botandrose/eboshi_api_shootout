from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()

class Client(db.Model):
    __tablename__ = 'clients'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    address = db.Column(db.String(255))
    city = db.Column(db.String(255))
    state = db.Column(db.String(255))
    zip = db.Column(db.String(255))
    country = db.Column(db.String(255))
    email = db.Column(db.String(255))
    contact = db.Column(db.String(255))
    phone = db.Column(db.String(255))
    created_at = db.Column(db.DateTime)
    updated_at = db.Column(db.DateTime)

    def __init__(self, attribute):
        self.name = attribute['name']
        self.email = attribute['email']
        self.address = attribute['address']
        self.city = attribute['city']
        self.state = attribute['state']
        self.zip = attribute['zip']
        self.country = attribute['country']
        self.email = attribute['email']
        self.contact = attribute['contact']
        self.phone = attribute['phone']
        self.created_at = attribute['created_at'][:-1] # Remove Z to make msql happy
        self.updated_at = attribute['updated_at'][:-1]

    def __repr__(self):
        return '<Clients %r>' % self.name

    @property
    def as_dict(self):
        attributes = {col.name: getattr(self, col.name) for col in self.__table__.columns}
        del attributes['id']

        # Python datetime objects don't have timezone info by default
        attributes['created_at'] = self.created_at.isoformat() + 'Z'
        attributes['updated_at'] = self.updated_at.isoformat() + 'Z'

        clients = {
            'type': 'clients',
            'id': unicode(self.id),
            'attributes': attributes
        }
        return clients
