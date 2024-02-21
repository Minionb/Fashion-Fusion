const {
  UserManagementController,
  ProductManagementController,
  OrderManagementController,
} = require("./controllers/index");
const express = require("express");
const dbConfig = require("./dbConfig");

let SERVER_NAME = "fashion_fusion-api";
let HOST = "127.0.0.1";
let PORT = process.env.PORT || 3000;

dbConfig.connectDB();
const server = express();
// Middleware to parse JSON bodies
server.use(express.json());

// Launch apis:
new UserManagementController().initApis(server);
new ProductManagementController().initApis(server);
new OrderManagementController().initApis(server);

server.listen(PORT, HOST, function () {
  console.log("Server %s listening at http://%s:%s", server.name, HOST, PORT);
});
