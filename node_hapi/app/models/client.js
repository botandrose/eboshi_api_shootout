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

    serialize() {
        const attributes = _.chain(this)
            .omit('id')
            .assign({
                created_at: moment(this.created_at).utc().format('YYYY-MM-DDTHH:mm:ss[Z]'),
                updated_at: moment(this.updated_at).utc().format('YYYY-MM-DDTHH:mm:ss[Z]')
            })
            .value();

        return {
            type: 'clients',
            id: this.id.toString(),
            attributes: attributes
        };
    }
}
