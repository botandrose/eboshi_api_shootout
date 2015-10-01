import * as Hapi from 'hapi';

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

server.start(() => console.log('Hapi server started'));
