const mongoose = require("mongoose");

const cartItemSchema = new mongoose.Schema({
  productId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
  quantity: { type: Number, required: true },
});

const cartSchema = new mongoose.Schema({
  customerId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
  cartItems: [cartItemSchema],
});

module.exports = mongoose.model("cart", cartSchema);
