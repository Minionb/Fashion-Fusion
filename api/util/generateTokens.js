const jwt = require("jsonwebtoken");
const { secret_jwt_key, tokenExpiry } = require("./properties");

const refreshTokens = [];

function generateTokens(user, userType) {
  const accessToken = jwt.sign({ userId: user._id, userType }, secret_jwt_key, {
    expiresIn: tokenExpiry,
  });
  const refreshToken = jwt.sign({ userId: user._id, userType }, secret_jwt_key);
  refreshTokens.push(refreshToken);
  return { accessToken, refreshToken };
}

module.exports = { generateTokens };
