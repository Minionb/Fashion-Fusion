const mongoose = require("mongoose");

const deliverySchema = new mongoose.Schema({
  method: {
    type: String,
    required: true,
  },
  courier: {
    type: String,
    required: true,
  },
  status: {
    type: String,
  },
});

const orderPaymentSchema = new mongoose.Schema({
  method: {
    type: String,
    required: true,
  },
  cardNumber: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    require: true,
  },
});

const orderItemSchema = new mongoose.Schema({
  productId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
  quantity: { type: Number, required: true },
  price: { type: Number, require: true },
});

const orderSchema = new mongoose.Schema({
  customerId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
  cartItems: [orderItemSchema],
  status: { type: String },
  payment: { type: orderPaymentSchema },
  delivery: { type: deliverySchema },
  totalAmount: { type: Number, require: true },
});

orderSchema.set("timestamps", true);

module.exports = mongoose.model("order", orderSchema);
