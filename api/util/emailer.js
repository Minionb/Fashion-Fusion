const nodemailer = require("nodemailer");

const emailer_properties = {
  service: "gmail",
  user: process.env.FF_EMAIL,
  pass: process.env.FF_EMAIL_PASS,
};
// Initialize Nodemailer transporter with your email credentials
const transporter = nodemailer.createTransport({
  service: emailer_properties.service,
  auth: {
    user: emailer_properties.user,
    pass: emailer_properties.pass,
  },
});

async function sendMail({ to, subject, text }) {
  const mailOptions = {
    from: emailer_properties.user,
    to,
    subject,
    text,
  };

  return new Promise((resolve, reject) => {
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error(error);
        reject("Failed to send email");
      } else {
        console.log("Email sent: " + info.response);
        resolve();
      }
    });
  });
}
module.exports = { transporter, sendMail };
