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
    if (next)
      next(); // Call next middleware
  } catch (error) {
    return res.status(401).send({
      message: error.message,
    });
  }
}

// Middleware to verify JWT token for admin
async function verifyAdminToken(req, res, next) {
  await verifyToken(req, res, () => {
    if (req.userType !== "admin") {
      return res.status(401).send({ message: "Unauthorized" });
    } else if (next) {
      next();
    };
  });
}

module.exports = { verifyAdminToken, verifyToken };
