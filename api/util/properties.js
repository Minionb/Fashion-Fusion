const secret_jwt_key = "todo-change-fashion-fusion-key";
const tokenExpiry = "1h";
const app_properties = {
  host: "127.0.0.1",
  port: process.env.PORT || 3000,
  server: "http://127.0.0.1:3000",
};

module.exports = { secret_jwt_key, tokenExpiry, app_properties };
