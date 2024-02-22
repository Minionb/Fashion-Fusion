const bcrypt = require("bcrypt");
const { CustomersModel, ResetTokensModel } = require("../schema/index");
const { app_properties } = require("../util/properties");
const { sendMail } = require("../util/emailer");
const crypto = require("crypto");

async function postResetPassword(req, res) {
  const { email } = req.body;

  try {
    const existingCustomer = await CustomersModel.findOne({ email });
    if (!existingCustomer) {
      return res.status(404).send("Email not found");
    }

    const token = crypto.randomBytes(20).toString("hex");
    await ResetTokensModel.create({
      customerId: existingCustomer._id,
      token,
      email,
    });

    const resetLink = `${app_properties.server}/customers/reset-password/${token}`;
    const mailOptions = {
      to: email,
      subject: "Reset your password",
      text: `Click on the following link to reset your password: ${resetLink}`,
    };

    await sendMail(mailOptions);
    res.send("Reset email sent");
  } catch (error) {
    console.error(error);
    res.status(500).send("Failed to process request");
  }
}
async function postSetPassword(req, res) {
  const { token, newPassword } = req.body;

  try {
    // Find the token in the database
    const resetToken = await ResetTokensModel.findOne({ token });

    if (resetToken) {
      // Delete the token from the database
      await ResetTokensModel.deleteOne({ _id: resetToken._id });
      // Find the user associated with the token
      const customer = await CustomersModel.findById(resetToken.customerId);

      if (customer) {
        // Update user's password
        customer.password = await bcrypt.hash(newPassword, 10);
        await customer.save();

        res.send("Password reset successfully");
      } else {
        res.status(404).send("User not found");
      }
    } else {
      res.status(400).send("Invalid or expired token");
    }
  } catch (error) {
    console.error(error);
    res.status(500).send("Failed to process request");
  }
}

class ResetPasswordController {
  initApis(server) {
    // Endpoint to request password reset
    server.post("/customers/reset-password", postResetPassword);
    server.post("/customers/set-password", postSetPassword);
  }
}

module.exports = ResetPasswordController;
