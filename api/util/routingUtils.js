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


// Function to attach a route for handling file uploads to the server
const attachUploadRoute = (
  server,
  method,
  path,
  uploadHandler,
  handler,
  auth = null
) => {
  // Check if authentication is required for this route
  if (auth === "any") {
    // If authentication required for any user, attach the route with verifyToken middleware and uploadHandler
    server[method](path, uploadHandler, (req, res) => {
      verifyToken(req, res, () => handler(req, res));
    });
  } else if (auth === "admin") {
    // If authentication required for admin, attach the route with verifyAdminToken middleware and uploadHandler
    server[method](path, uploadHandler, (req, res) => {
      verifyAdminToken(req, res, () => handler(req, res));
    });
  } else {
    // If no authentication required, attach the route with only uploadHandler
    server[method](path, uploadHandler, handler);
  }
  // Log the attached route
  console.log(`  - ${method} ${path}`);
};

// Exporting attachRoute and attachUploadRoute functions for use in other modules
module.exports = { attachRoute, attachUploadRoute };
