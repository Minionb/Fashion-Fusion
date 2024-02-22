const jwt = require("jsonwebtoken");
const { secret_jwt_key } = require("./properties");

// In-memory blacklist to store invalidated tokens
const blacklisted_tokens = new Set();
exports.blacklisted_tokens = blacklisted_tokens;

// Function to verify the JWT token asynchronously
async function verifyJWT(token) {
  return new Promise((resolve, reject) => {
    jwt.verify(token, secret_jwt_key, (err, decoded) => {
      if (err) {
        reject(err);
      } else {
        resolve(decoded);
      }
    });
  });
}

// Middleware to verify JWT token
async function verifyToken(req, res, next) {
  const token = req.headers.authorization;

  if (!token) {
    return res.status(401).send({ message: "Unauthorized: No token provided" });
  }

  if (blacklisted_tokens.has(token)) {
    return res.status(401).send({
      message: "Unauthorized: Token has been invalidated",
    });
  }

  try {
    const decoded = await verifyJWT(token);
    req.userId = decoded.userId;
    req.userType = decoded.userType;
  } catch (error) {
    return res.status(401).send({ message: "Unauthorized: Invalid token" });
  }
}
// Middleware to verify JWT token for admin
async function verifyAdminToken(req, res, next) {
  verifyToken(req, res, next);
  if (req.userType !== "admin") {
    res.status(401).send({ message: "Unauthorized" });
  }
}

module.exports = { verifyAdminToken, verifyToken };
