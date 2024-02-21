const mongoose = require("mongoose");

const favoriteSchema = new mongoose.Schema({
  customerId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
  favoriteItems: [mongoose.Schema.Types.ObjectId],
});

module.exports = mongoose.model("favorite", favoriteSchema);
