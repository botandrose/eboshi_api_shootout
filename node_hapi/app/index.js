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
        const clients = await Client.all();
        reply({ data: _.map(clients, Client.serialize) });
    }
});

server.route({
    method: 'POST',
    path: '/api/clients',
    handler: async (request, reply) => {
        const client = await Client.create(request.payload.data.attributes);
        reply({ data: Client.serialize(client) }).code(201);
    }
});

server.route({
    method: 'DELETE',
    path: '/api/clients/{id}',
    handler: async (request, reply) => {
        const rowsDeleted = await knex('clients').where('id', request.params.id).del();
        return rowsDeleted ? reply().code(204) : reply().code(404);
    }
});

server.start(() => console.log('Hapi server started'));
