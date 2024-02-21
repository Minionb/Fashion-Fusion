const mongoose = require("mongoose");

const resetTokenSchema = new mongoose.Schema({
  customerId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
  token: { type: String, required: true },
  email: { type: String, required: true },
  createdAt: { type: Date, expires: "1d", default: Date.now },
});

module.exports = mongoose.model("resetToken", resetTokenSchema);
