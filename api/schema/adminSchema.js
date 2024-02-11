const mongoose = require ("mongoose");

// Define customer data schema
const adminSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true
      },
      password: {
        type: String,
        required: true
      },
      first_name: {
        type: String,
        required: true
      },
      last_name: {
        type: String,
        required: true
      },
      telephone_number: {
        type: String,
        required: true
      },
      job_title: {
        type: String,
        required: true
      },

});

module.exports = mongoose.model('admins', adminSchema);