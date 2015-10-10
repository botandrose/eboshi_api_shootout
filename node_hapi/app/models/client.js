import * as _ from 'lodash';
import moment from 'moment';
import { knex } from '../cfg/knex';

export default class Client {
    static async all() {
        return await knex.select().table('clients');
    }

    static async create(attributes) {
        const client = _.assign({}, attributes, {
            created_at: new Date(attributes.created_at),
            updated_at: new Date(attributes.updated_at)
        });
        client.id = await knex('clients').insert(client);
        return client;
    }

    static async destroy(id) {
        return await knex('clients').where('id', id).del();
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
