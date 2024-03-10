const mongoose = require("mongoose");

const paymentSchema = new mongoose.Schema({
  method: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  cardNumber: {
    type: String,
    required: true,
  },
  expirationDate: {
    type: Date,
    required: true,
  },
  cvv: {
    type: String,
    required: true,
  },
});
const addressSchema = new mongoose.Schema({
  addresNickName: {
    type: String,
    required: true,
  },
  addressLine1: {
    type: String,
    required: true,
  },
  addressLine2: {
    type: String,
  },
  zipCode: {
    type: String,
    required: true,
  },
  city: {
    type: String,
    required: true,
  },
  country: {
    // default CANADA
    type: String,
    required: true,
  },
});

// Define customer data schema
const customerSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    required: true,
  },
  first_name: {
    type: String,
    required: true,
  },
  last_name: {
    type: String,
    required: true,
  },
  date_of_birth: {
    type: Date,
    required: true,
  },
  gender: {
    type: String,
    required: true,
  },
  telephone_number: {
    type: String,
    required: true,
  },
  payments: [paymentSchema],
  addresses: [addressSchema],
});
// Add timestamps
customerSchema.set("timestamps", true);
module.exports = mongoose.model("customers", customerSchema);
