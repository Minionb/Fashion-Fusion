const jwt = require("jsonwebtoken");
const { secret_jwt_key } = require("./properties");

// In-memory blacklist to store invalidated tokens
const blacklisted_tokens = new Set();
exports.blacklisted_tokens = blacklisted_tokens;

// Middleware to verify JWT token
function verifyToken(req, res, next) {
  // Get the token from the request headers
  const token = req.headers.authorization;

  // Check if token is provided
  if (!token) {
    return res.send(401, { message: "Unauthorized: No token provided" });
  }

  // Check if token is in the blacklist
  if (blacklisted_tokens.has(token)) {
    return res.send(401, {
      message: "Unauthorized: Token has been invalidated",
    });
  }

  // Verify the token
  jwt.verify(token, secret_jwt_key, (err, decoded) => {
    if (err) {
      return res.send(401, { message: "Unauthorized: Invalid token" });
    }
    // If token is valid, attach the decoded user ID to the request object
    req.userId = decoded.userId;
    req.userType = decoded.userType;
    next();
  });
}

// Middleware to verify JWT token for admin
function verifyAdminToken(req, res, next) {
  verifyToken(req, res, next);
  if (req.userType !== "admin") {
    res.status(401).send({ message: "Unauthorized" });
  }
}
module.exports = { verifyAdminToken, verifyToken };
