const { verifyToken, verifyAdminToken } = require("../util/verifyToken");
const attachRoute = (server, method, path, handler, auth = null) => {
  if (auth === "any") {
    server[method](path, verifyToken, handler);
  } else if (auth === "admin") {
    server[method](path, verifyAdminToken, handler);
  } else {
    server[method](path, handler);
  }
  console.log(`  - ${method} ${path}`);
};

const attachUploadRoute = (
  server,
  method,
  path,
  uploadHandler,
  handler,
  auth = null
) => {
  if (auth === "any") {
    server[method](path, uploadHandler, (req, res) => {
      verifyToken(req, res, uploadHandler);
    });
  } else if (auth === "admin") {
    server[method](path, uploadHandler, (req, res) => {
      verifyAdminToken(req, res, handler);
    });
  } else {
    server[method](path, uploadHandler, handler);
  }
  console.log(`  - ${method} ${path}`);
};

module.exports = { attachRoute, attachUploadRoute };
