const {
  UserManagementController,
  ProductManagementController,
  OrderManagementController,
  ResetPasswordController,
} = require("./controllers/index");
const express = require("express");
const dbConfig = require("./dbConfig");
const { app_properties } = require("./util/properties");

let SERVER_NAME = "fashion_fusion-api";
let HOST = app_properties.host;
let PORT = app_properties.port;

dbConfig.connectDB();
const server = express();
// Middleware to parse JSON bodies
server.use(express.json());

// Launch apis:
console.log('---------------------------');
console.log('|      API Endpoints      |');
console.log('---------------------------');
new UserManagementController().initApis(server);
new ProductManagementController().initApis(server);
new OrderManagementController().initApis(server);
new ResetPasswordController().initApis(server);

server.listen(PORT, HOST, function () {
  console.log("Server %s listening at http://%s:%s", server.name, HOST, PORT);
});
