import * as _ from 'lodash';
import moment from 'moment';
import { knex } from '../cfg/knex';

export default class Client {
    static async all() {
        const results = await knex.select().table('clients');
        return _.map(results, (attributes) => { return new Client(attributes); });
    }

    static async create(attributes) {
        const id = await knex('clients').insert(attributes);
        return _.assign(new Client(attributes), {
            id: id,
            created_at: new Date(attributes.created_at),
            updated_at: new Date(attributes.updated_at)
        });
    }

    static async destroy(id) {
        return await knex('clients').where('id', id).del();
    }

    constructor(attributes) {
        _.assign(this, attributes);
    }

    // Serialize a client for response
    static serialize(client) {
        const attributes = _.chain(client)
            .omit('id')
            .assign({
                created_at: moment(client.created_at).utc().format('YYYY-MM-DDTHH:mm:ss[Z]'),
                updated_at: moment(client.updated_at).utc().format('YYYY-MM-DDTHH:mm:ss[Z]')
            })
            .value();

        return {
            type: 'clients',
            id: client.id.toString(),
            attributes: attributes
        };
    }
}
