// Helper function to mask credit card numbers
function maskCreditNumber(cardNumber) {
  return "**** **** **** " + cardNumber.slice(-4);
}

module.exports = {
  maskCreditNumber,
};
