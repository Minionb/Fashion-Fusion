const mongoose = require("mongoose");

const resetPasswordSchema = new mongoose.Schema({
  customerId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
  email: { type: String, required: true },
  password: { type: String, required: true },
  createdAt: { type: Date, expires: "1d", default: Date.now },
});

module.exports = mongoose.model("resetPassword", resetPasswordSchema);
