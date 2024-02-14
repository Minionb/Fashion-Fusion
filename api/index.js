const {
  UserManagementController,
  ProductManagementController,
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

server.listen(PORT, HOST, function () {
  console.log("Server %s listening at %s", server.name, server.url);
  console.log("**** Resources: ****");
  console.log("********************");
  console.log(" /customers/register");
  console.log(" /customer/:id");
  console.log(" /admins");
  console.log(" /admins/:id");
});

// Launch apis:
new UserManagementController().initApis(server);
new ProductManagementController().initApis(server);
