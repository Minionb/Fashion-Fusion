const bcrypt = require("bcrypt");
const { CustomersModel, AdminsModel } = require("../schema/index");
const { verifyToken, verifyAdminToken } = require("../util/verifyToken");
const { generateTokens } = require("../util/generateTokens");
const { maskCreditNumber } = require("../util/cardUtils");

// Reusable function to reset password for both customers and admins
async function resetPassword(req, res, userModel) {
  try {
    const { email, newPassword } = req.body;

    // Find the user with the provided email
    const user = await userModel.findOne({ email });

    // If user is not found, return an error
    if (!user) {
      return res.send(404, { message: "User not found" });
    }

    // Hash the new password
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Update the user's password
    await userModel.updateOne(
      { email },
      { $set: { password: hashedPassword } }
    );

    res.send(200, { message: "Password reset successfully" });
  } catch (error) {
    console.error("Password reset error:", error);
    res.send(500, { message: "Internal server error" });
  }
}

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

function getAdmins(server) {
  // Get all admins in the system
  server.get("/admins", verifyAdminToken, function (req, res, next) {
    // Query the database to retrieve all customers, excluding the password field
    AdminsModel.find({}, { password: 0 })
      .sort({ lastName: "asc" })
      .then((admins) => {
        // Return all of the users in the system
        res.send(admins);
        return next();
      })
      .catch((error) => {
        return next(new Error(JSON.stringify(error.errors)));
      });
  });
}

function registerAdmin(server) {
  // Create or add a new admins
  //defines the callback function that handles the incoming request, takes in three parameters: req (request), res (response), and next (next middleware).
  server.post("/admins/register", async (req, res) => {
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
  });
}

function loginAdmin(server) {
  server.post("/admins/login", async (req, res) => {
    try {
      // Call the login function to handle login logic
      const admin = await login(req, res, AdminsModel);
    } catch (error) {
      console.error("Login error:", error);
      res.send(500, { message: "Internal server error" });
    }
  });
}

function logoutAdmin(server) {
  // Logout API for admins
  server.post("/admins/logout", verifyToken, async (req, res) => {
    res.send("Admin logged out successfully");
  });
}

function resetAdminsPassword(server) {
  // Password reset API for admins
  server.post("/admins/reset-password", async (req, res) => {
    await resetPassword(req, res, AdminsModel);
  });
}

function getAdminsById(server) {
  // API endpoint to get admin by ID
  server.get("/admins/:id", verifyAdminToken, async (req, res) => {
    await getUserById(req, res, AdminsModel);
  });
}

function registerCustomer(server) {
  // Create or add a new customers
  // defines the callback function that handles the incoming request, takes in three parameters: req (request), res (response), and next (next middleware).
  server.post("/customers/register", async (req, res) => {
    try {
      const {
        email,
        password,
        first_name,
        last_name,
        address,
        date_of_birth,
        gender,
        telephone_number,
      } = req.body;

      // Check if the email is already registered
      const existingCustomer = await CustomersModel.findOne({ email });
      if (existingCustomer) {
        return res.send(400, { message: "Email already registered" });
      }

      // Hash the password
      const hashedPassword = await bcrypt.hash(password, 10);

      // Create a new customer object
      const newCustomer = new CustomersModel({
        email,
        password: hashedPassword,
        first_name,
        last_name,
        address,
        date_of_birth,
        gender,
        telephone_number,
      });

      // Save the new customer to the database
      await newCustomer.save();

      res.send(201, { message: "Customer registered successfully" });
    } catch (error) {
      console.error("Registration error:", error);
      res.send(500, { message: "Internal server error" });
    }
  });
}

function getCustomers(server) {
  // Get all customers in the system
  server.get("/customers", verifyAdminToken, function (req, res, next) {
    // Query the database to retrieve all customers, excluding the password field
    CustomersModel.find({}, { password: 0 })
      .then((customers) => {
        // Return all of the users in the system
        res.send(customers);
        return next();
      })
      .catch((error) => {
        return next(new Error(JSON.stringify(error.errors)));
      });
  });
}

// Function to convert MM/YYYY string to Date object for cardExpiryDate
function convertExpiryToDate(expirationDate) {
  const [month, year] = expirationDate.split("/");
  return new Date(parseInt(year), parseInt(month) - 1, 1);
}

// Function to convert DD-MM-YYYY string to Date object for date_of_birth
function convertDOBToDate(dateOfBirth) {
  const [day, month, year] = dateOfBirth.split("-");
  return new Date(parseInt(year), parseInt(month) - 1, parseInt(day));
}
// Function to update customer data
async function updateCustomerData(customerId, updateData) {
  const existingCustomer = await CustomersModel.findById(customerId);
  if (!existingCustomer) {
    throw new Error("Customer not found");
  }

  // Convert card expiry from MM/YYYY to Date object before applying updates
  if (updateData.payments && updateData.payments.length > 0) {
    updateData.payments.forEach((payment) => {
      if (payment.expirationDate) {
        payment.expirationDate = convertExpiryToDate(payment.expirationDate);
      }
    });
  }

  // Convert date of birth from DD/MM/YYYY to Date object before applying updates
  if (updateData.date_of_birth) {
    existingCustomer.date_of_birth = convertDOBToDate(updateData.date_of_birth);
    delete updateData.date_of_birth;
  }

  existingCustomer.set(updateData);
  return existingCustomer.save();
}

/**
 * PUT /customer/:id route for updating customer information
 * @param {*} server
 */
function putCustomer(server) {
  server.put("/customers/:id", async (req, res) => {
    const customerId = req.params.id;
    const updateData = req.body;
    delete updateData.email; // Exclude email field from update data

    try {
      const updatedCustomer = await updateCustomerData(customerId, updateData);
      res.json(updatedCustomer);
    } catch (error) {
      console.error(error);
      res.status(404).json({ message: error.message || "Customer not found" });
    }
  });
}

function loginCustomer(server) {
  server.post("/customers/login", async (req, res) => {
    try {
      // Call the login function to handle login logic
      const admin = await login(req, res, CustomersModel);
    } catch (error) {
      console.error("Login error:", error);
      res.send(500, { message: "Internal server error" });
    }
  });
}

function logoutCustomer(server) {
  // Logout API for customers
  server.post("/customers/logout", verifyToken, async (req, res) => {
    // req.session.customerId = null; // Clear customer session ID
    res.send("Customer logged out successfully");
  });
}

function resetCustomerPassword(server) {
  // Password reset API for customers
  server.post("/customers/reset-password", async (req, res) => {
    await resetPassword(req, res, CustomersModel);
  });
}

function getCustomersById(server) {
  // API endpoint to get customer by ID
  server.get("/customers/:id", async (req, res) => {
    await getUserById(req, res, CustomersModel);
  });
}

class UserManagementController {
  /**
   * Initializes the apis
   * @param {server} server
   */
  initApis(server) {
    getAdmins(server);
    registerAdmin(server);
    loginAdmin(server);
    logoutAdmin(server);
    resetAdminsPassword(server);
    getAdminsById(server);

    getCustomers(server);
    putCustomer(server);
    registerCustomer(server);
    loginCustomer(server);
    logoutCustomer(server);
    resetCustomerPassword(server);
    getCustomersById(server);
  }
}

module.exports = UserManagementController;
