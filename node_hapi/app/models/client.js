import * as _ from 'lodash';
import moment from 'moment';
import { knex } from '../cfg/knex';

export async function all() {
    return await knex.select().table('clients');
}

export async function create(attributes) {
    const client = _.assign({}, attributes, {
        created_at: new Date(attributes.created_at),
        updated_at: new Date(attributes.updated_at)
    });
    client.id = await knex('clients').insert(client);
    return client;
}

export async function destroy(id) {
    return await knex('clients').where('id', id).del();
}

// Serialize a client for response
export function serialize(client) {
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

