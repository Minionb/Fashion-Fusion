// Function to convert MM/YYYY string to Date object for cardExpiryDate
function convertExpiryToDate(expirationDate) {
  const [month, year] = expirationDate.split("/");
  return new Date(parseInt(year), parseInt(month) - 1, 1);
}

module.exports = {
    convertExpiryToDate
}