const mongoose = require("mongoose");

const productImageSchema = new mongoose.Schema({
  product_id: {
    type: String,
    required: true,
  },
  filename: {
    type: String,
    required: true,
  },
  contentType: {
    type: String,
    required: true,
  },
  data: {
    type: Buffer,
    required: true,
  },
});

productImageSchema.set("timestamps", true);
module.exports = mongoose.model("productImages", productImageSchema);
