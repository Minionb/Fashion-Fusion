const bcrypt = require("bcrypt");
const {
  CustomersModel,
  ResetPasswordModel: ResetPasswordModel,
} = require("../schema/index");
const { app_properties } = require("../util/properties");
const { sendMail } = require("../util/emailer");
const { attachRoute } = require("../util/routingUtils");
const crypto = require("crypto");

async function postResetPassword(req, res) {
  const { email } = req.body;

  try {
    const existingCustomer = await CustomersModel.findOne({ email: email });
    if (!existingCustomer) {
      return res.status(404).send("Email not found");
    }

    const tempPassword = crypto.randomBytes(8).toString("hex");
    const hashedPassword = await bcrypt.hash(tempPassword, 10);

    await ResetPasswordModel.deleteMany({ email: email });
    await ResetPasswordModel.create({
      customerId: existingCustomer._id,
      password: hashedPassword,
      email,
    });

    existingCustomer.password = hashedPassword;
    console.log(
      `customerId=${existingCustomer._id} updated with temporary password`
    );
    existingCustomer.save();

    const mailOptions = {
      to: email,
      subject: "Reset your password",
      text: `Thanks for contacting Fashion Fushion. Your temporary password : ${tempPassword}`,
    };

    await sendMail(mailOptions);
    res.send({ message: "Reset email sent" });
  } catch (error) {
    console.error(error);
    res.status(500).send("Failed to process request");
  }
}
async function postSetPassword(req, res) {
  const customerId = req.userId;
  const { oldPassword, password } = req.body;

  try {
    // Find the user associated with the token
    const customer = await CustomersModel.findById(customerId);

    if (customer) {
      const passwordMatch = await bcrypt.compare(
        oldPassword,
        customer.password
      );
      if (!passwordMatch) throw new Error("Password not matching!");
      // Update user's password
      customer.password = await bcrypt.hash(password, 10);
      await customer.save();

      res.send("Password reset successfully");
    } else {
      res.status(404).send("User not found");
    }
  } catch (error) {
    console.error(error);
    res.status(500).send("Failed to process request");
  }
}

class ResetPasswordController {
  initApis(server) {
    // Endpoint to request password reset
    attachRoute(server, "post", "/customers/reset-password", postResetPassword);
    attachRoute(
      server,
      "post",
      "/customers/set-password",
      postSetPassword,
      "any"
    );
  }
}

module.exports = ResetPasswordController;
