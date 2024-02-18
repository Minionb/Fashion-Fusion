const mongoose = require("mongoose");
const ProductImagesModel = require("./productImageSchema");

// Define customer data schema
const inventorySchema = new mongoose.Schema({
  size: {
    type: String,
    required: true,
  },
  quantity: {
    type: Number,
    required: true,
  },
});

// Define product data schema
const productSchema = new mongoose.Schema({
  product_name: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  product_description: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  tags: {
    type: String,
    required: true,
  },
  sold_quantity: {
    type: Number,
    required: true,
  },
  inventory: [inventorySchema],
  images: [
    {
      type: mongoose.Schema.Types.ObjectId,
    },
  ],
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
  },
});

productSchema.set("timestamps", true);
module.exports = mongoose.model("products", productSchema);
