const bcrypt = require("bcrypt");
const { CustomersModel, AdminsModel } = require("../schema/index");
const { verifyToken, verifyAdminToken } = require("../util/verifyToken");
const { attachRoute } = require("../util/routingUtils");
const { generateTokens } = require("../util/generateTokens");
const { maskCreditNumber } = require("../util/cardUtils");
const { convertExpiryToDate } = require("../util/formattingUtils");

// Function to handle customer and admin login
async function login(req, res, userModel) {
  try {
    const { email, password } = req.body;

    // Find the user with the provided email
    const user = await userModel.findOne({ email });

    // If user is not found, return an error
    if (!user) {
      return res.send(404, { message: "User not found" });
    }

    // Compare the provided password with the hashed password stored in the database
    const passwordMatch = await bcrypt.compare(password, user.password);

    // If passwords don't match, return an error
    if (!passwordMatch) {
      return res.send(401, { message: "Invalid password" });
    }

    const userType = userModel === CustomersModel ? "customer" : "admin";

    // If passwords match, generate a JWT tokens
    const { accessToken, refreshToken } = generateTokens(user, userType);

    const tokens = { accessToken, refreshToken };

    // Return the JWT as a response
    res.send(200, tokens);
  } catch (error) {
    console.error("Login error:", error);
    res.send(500, { message: "Internal server error" });
  }
}

// Reusable function to get user by ID
async function getUserById(req, res, userModel) {
  try {
    const userId = req.params.id;

    // Find the user by ID
    const user = await userModel.findById(userId, { password: 0 });

    // If user is not found, return 404 Not Found
    if (!user) {
      return res.send(404, { message: `${userModel.modelName} not found` });
    }

    // If user is a customer and has payments, hide credit card details except last 4 digits
    if (
      userModel === CustomersModel &&
      user.payments &&
      user.payments.length > 0
    ) {
      user.payments.forEach((payment) => {
        if (payment.cardNumber) {
          payment.cardNumber = maskCreditNumber(payment.cardNumber);
        }
      });
    }
    // If user is found, return it as JSON response
    res.send(200, user);
  } catch (error) {
    console.error("Error fetching user:", error);
    res.send(500, { message: "Internal server error" });
  }
}

async function getAdmins(req, res) {
  // Query the database to retrieve all customers, excluding the password field
  AdminsModel.find({}, { password: 0 })
    .sort({ lastName: "asc" })
    .then((admins) => {
      // Return all of the users in the system
      res.status(200).send(admins);
    })
    .catch((error) => {
      res.status(500).send({ message: error.message });
    });
}

async function registerAdmin(req, res) {
  // Create or add a new admins
  try {
    const {
      email,
      password,
      first_name,
      last_name,
      telephone_number,
      job_title,
    } = req.body;

    // Check if the email is already registered
    const existingAdmin = await AdminsModel.findOne({ email });
    if (existingAdmin) {
      return res.send(400, { message: "Email already registered" });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new admin object
    const newAdmin = new AdminsModel({
      email,
      password: hashedPassword,
      first_name,
      last_name,
      telephone_number,
      job_title,
    });

    // Save the new admin to the database
    await newAdmin.save();

    res.send(201, { message: "Admin registered successfully" });
  } catch (error) {
    console.error("Admin registration error:", error);
    res.send(500, { message: "Internal server error" });
  }
}

async function loginAdmin(req, res) {
  try {
    const admin = await login(req, res, AdminsModel);
  } catch (error) {
    console.error("Login error:", error);
    res.send(500, { message: "Internal server error" });
  }
}

function logoutAdmin(req, res) {
  res.status(200).send("Admin logged out successfully");
}

async function getAdminsById(req, res) {
  await getUserById(req, res, AdminsModel);
}

async function registerCustomer(req, res) {
  try {
    var newCustomerRequest = req.body;

    // Check if the email is already registered
    const existingCustomer = await CustomersModel.findOne({
      email: newCustomerRequest.email,
    });
    if (existingCustomer) {
      return res.send(400, { message: "Email already registered" });
    }
    newCustomerRequest = await normalizeCustomerData(newCustomerRequest);
    const newCustomer = new CustomersModel(newCustomerRequest);

    await newCustomer.save();

    res.send(201, { message: "Customer registered successfully" });
  } catch (error) {
    console.error("Registration error:", error);
    res.send(500, { message: "Internal server error" });
  }
}

function getCustomers(req, res) {
  const filter = buildFilter(req.query);
  // Query the database to retrieve all customers with filter, excluding the password field
  CustomersModel.find(filter, { password: 0 })
    .then((customers) => {
      // Return all of the users in the system
      return res.status(200).send(customers);
    })
    .catch((error) => {
      console.error(error.message);
      return res.status(500).json({ message: "Something went wrong" });
    });
}

function buildFilter(query) {
  const filter = {};
  if (query.first_name)
    filter.first_name = RegExp(query.first_name, "i");
  if (query.last_name)
    filter.last_name = RegExp(query.last_name, "i");
  return filter;
}

// Function to convert DD-MM-YYYY string to Date object for date_of_birth
// Function to update customer data
async function updateCustomerData(customerId, updateData) {
  const existingCustomer = await CustomersModel.findById(customerId);
  if (!existingCustomer) {
    throw new Error("Customer not found");
  }
  if(updateData.newPassword)  {
    const passwordMatch = await bcrypt.compare(updateData.oldPassword, user.password);
    if(!passwordMatch)
      throw new Error("Password not matching!");
  }
  // Convert card expiry from MM/YYYY to Date object before applying updates
  updateData = await normalizeCustomerData(updateData);

  existingCustomer.set(updateData);

  return existingCustomer.save();
}

async function normalizeCustomerData(updateData) {
  if (updateData.payments) {
    updateData.payments.forEach((payment) => {
      if (payment.expirationDate) {
        payment.expirationDate = convertExpiryToDate(payment.expirationDate);
      }
    });
  }

  // Convert date of birth from DD/MM/YYYY to Date object before applying updates
  if (updateData.date_of_birth) {
    // updateData.date_of_birth = convertDOBToDate(updateData.date_of_birth);
  }

  if (updateData.addresses) {
    updateData.addresses.forEach((add) => {
      if (!add.country) add.country = "Canada";
    });
  }

  if (updateData.password) {
    updateData.password = await bcrypt.hash(updateData.password, 10);
  }
  return updateData;
}

/**
 * PUT /customer/:id route for updating customer information
 * @param {*} server
 */
async function putCustomer(req, res) {
  const customerId = req.params.id;
  const updateData = req.body;
  delete updateData.email; // Exclude email field from update data

  try {
    const updatedCustomer = await updateCustomerData(customerId, updateData);
    updatedCustomer.password = null;
    res.status(200).json(updatedCustomer);
  } catch (error) {
    console.error(error);
    res.status(404).json({ message: error.message || "Customer not found" });
  }
}

async function loginCustomer(req, res) {
  try {
    const admin = await login(req, res, CustomersModel);
  } catch (error) {
    console.error("Login error:", error);
    res.send(500, { message: "Internal server error" });
  }
}

function logoutCustomer(req, res) {
  // req.session.customerId = null; // Clear customer session ID
  res.send("Customer logged out successfully");
}

async function getCustomersById(req, res) {
  await getUserById(req, res, CustomersModel);
}

class UserManagementController {
  /**
   * Initializes the apis
   * @param {server} server
   */
  initApis(server) {
    console.log(`** Admin endpoints **`);
    attachRoute(server, "get", "/admins", getAdmins, "admin");
    attachRoute(server, "post", "/admins/register", registerAdmin);
    attachRoute(server, "post", "/admins/login", loginAdmin);
    attachRoute(server, "post", "/admins/logout", logoutAdmin, "admin");
    attachRoute(server, "get", "/admins/:id", getAdminsById, "admin");

    console.log(`** Customers endpoints **`);
    attachRoute(server, "get", "/customers", getCustomers, "any");
    attachRoute(server, "post", "/customers/register", registerCustomer);
    attachRoute(server, "post", "/customers/login", loginCustomer);
    attachRoute(server, "post", "/customers/logout", logoutCustomer, "any");
    attachRoute(server, "get", "/customers/:id", getCustomersById, "any");
    attachRoute(server, "put", "/customers/:id", putCustomer, "any");
  }
}

module.exports = UserManagementController;
