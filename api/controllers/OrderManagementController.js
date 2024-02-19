const { verifyToken, verifyAdminToken } = require("../util/verifyToken");
const { CartsModel } = require("../schema/index");
const { Types } = require("mongoose");

// Function to validate request body
const validateRequestBody = (req) => {
  const { productId, quantity } = req.body;

  if (!productId || !quantity) {
    throw new Error("Product ID and quantity are required");
  }

  return { productId, quantity };
};

// Function to find or create a cart
const findOrCreateCart = async (customerId, productId, quantity) => {
  let cart = await CartsModel.findOne({ customerId });

  if (!cart) {
    cart = new CartsModel({
      customerId,
      cartItems: [{ productId, quantity }],
    });
  }

  return cart;
};

// Function to add or update cart item
const addOrUpdateCartItem = (cart, productId, quantity) => {
  let existingCartItem = null;
  const productIdObj = new Types.ObjectId(productId); // Convert string to ObjectId

  cart.cartItems.forEach((item) => {
    // Convert item.productId to string for comparison
    if (item.productId.toString() === productIdObj.toString()) {
      existingCartItem = item;
    }
  });
  if (existingCartItem) {
    existingCartItem.quantity += quantity;
  } else {
    existingCartItem = { productId, quantity };
    cart.cartItems.push(existingCartItem);
  }

  return existingCartItem;
};

// POST /cart/items
function postCartItems(server) {
  server.post("/cart/items", verifyToken, async (req, res) => {
    try {
      const customerId = req.userId;
      const { productId, quantity } = validateRequestBody(req);
      let cart = await findOrCreateCart(customerId, productId, quantity);
      cart.customerId = customerId;

      addOrUpdateCartItem(cart, productId, quantity);

      await cart.save();

      res.status(201).json(cart);
    } catch (error) {
      console.error(error);
      res.status(400).json({ message: error.message });
    }
  });
}

// POST /cart/items
function postCartItems(server) {
  server.post("/cart/items", verifyToken, async (req, res) => {
    try {
      const customerId = req.userId;
      const { productId, quantity } = validateRequestBody(req);
      let cart = await findOrCreateCart(customerId, productId, quantity);
      cart.customerId = customerId;

      addOrUpdateCartItem(cart, productId, quantity);

      await cart.save();

      res.status(201).json(cart);
    } catch (error) {
      console.error(error);
      res.status(400).json({ message: error.message });
    }
  });
}

// DELETE /cart/items
function deleteCartItems(server) {
  server.delete("/cart/items", verifyToken, async (req, res) => {
    try {
      const customerId = req.userId;
      const cart = await CartsModel.findOne({ customerId });

      if (!cart) {
        return res.status(404).json({ message: "Cart not found" });
      }

      cart.cartItems = [];
      await cart.save();

      res.status(204).send();
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Internal Server Error" });
    }
  });
}

class OrderManagementController {
  /**
   * Initializes the apis
   * @param {server} server
   */
  initApis(server) {
    postCartItems(server);
    deleteCartItems(server);
  }
}

module.exports = OrderManagementController;
