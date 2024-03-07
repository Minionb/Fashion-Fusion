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
  address: {
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
});
// Add timestamps
customerSchema.set("timestamps", true);
module.exports = mongoose.model("customers", customerSchema);
