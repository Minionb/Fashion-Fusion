const { UserManagementController } = require('./controllers/index')

const dbConfig = require ("./dbConfig");

let SERVER_NAME = 'fashion_fusion-api'
let HOST = "127.0.0.1";
let PORT = process.env.PORT || 3000;

dbConfig.connectDB();

// Compiles the schema into a model, opening (or creating, if
// nonexistent) the collections in the MongoDB database
// let CustomersModel = require('./schema/customerSchema');
// const AdminsModel = require('./schema/adminSchema');
let errors = require('restify-errors');
let restify = require('restify')

server = restify.createServer({name: SERVER_NAME})

server.listen(PORT, HOST, function () {
    console.log('Server %s listening at %s', server.name, server.url)
    console.log('**** Resources: ****')
    console.log('********************')
    console.log(' /customers/register')
    console.log(' /customer/:id')
    console.log(' /admins')
    console.log(' /admins/:id')
})

server.use(restify.plugins.fullResponse());
server.use(restify.plugins.bodyParser());
// Add query parser middleware
server.use(restify.plugins.queryParser());

// Launch apis:
new UserManagementController().initApis(server)
