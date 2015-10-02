import 'babel/polyfill';
import * as Hapi from 'hapi';
import * as _ from 'lodash';

import { knex } from './cfg/knex';
import * as Client from './models/client';

const server = new Hapi.Server();

server.connection({
    host: 'localhost',
    port: 6969
});

server.route({
    method: 'GET',
    path: '/api/test',
    handler: (request, reply) => reply('Hello world')
});

server.route({
    method: 'GET',
    path: '/api/clients',
    handler: async (request, reply) => {
        const clients = await knex.select().table('clients');
        reply({ data: _.map(clients, Client.serialize) });
    }
});

server.start(() => console.log('Hapi server started'));
