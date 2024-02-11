let SERVER_NAME = 'patient-data-api'
let PORT = process.env.PORT || 3000;

const mongoose = require ("mongoose");
const username = "fashion_fusion_db_admin";
const password = "33r2DsHiw94xPJwx";
const dbname = "fashion_fusion";

// Atlas MongoDb connection string format
let uristring = 'mongodb+srv://'+username+':'+password+'@cluster0.w4uxyix.mongodb.net/'+dbname+
'?retryWrites=true&w=majority';
console.log(uristring)

// Makes db connection asynchronously
mongoose.connect(uristring, {useNewUrlParser: true});
const db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', ()=>{
  // we're connected!
  console.log("!!!! Connected to db: " + uristring)
});

// Compiles the schema into a model, opening (or creating, if
// nonexistent) the collections in the MongoDB database
let CustomersModel = require('./schema/customerSchema');
const AdminsModel = require('./schema/adminSchema');
let errors = require('restify-errors');
let restify = require('restify')

, server = restify.createServer({name: SERVER_NAME})

server.listen(PORT, function () {
    console.log('Server %s listening at %s', server.name, server.url)
    console.log('**** Resources: ****')
    console.log('********************')
    console.log(' /customers')
    console.log(' /customer/:id')
    console.log(' /admins')
    console.log(' /admins/:id')
})

server.use(restify.plugins.fullResponse());
server.use(restify.plugins.bodyParser());
// Add query parser middleware
server.use(restify.plugins.queryParser());


// ** Testing Code, inserting sample data into customers and admins collection **
// const payment = {
//     method: "Credit Card",
//     cardNumber: "1234567890123456",
//     expirationDate: new Date("2024-12-31"),
//     cvv: "123",
//   };

//   // Create a sample customer with the payment
//   const customer = new CustomersModel({
//     email: "example@example.com",
//     password: "password123",
//     first_name: "John",
//     last_name: "Doe",
//     address: "123 Main St",
//     date_of_birth: new Date("1990-01-01"),
//     gender: "Male",
//     telephone_number: "123-456-7890",
//     payments: [payment],
//   });

//   customer.save()
  

//   const admin = new AdminsModel({
//     email: "admin@example.com",
//     password: "admin123",
//     first_name: "John",
//     last_name: "Doe",
//     telephone_number: "123-456-7890",
//     job_title: "Admin",
//   });

//   admin.save()

