const { verifyToken, verifyAdminToken } = require("../util/verifyToken");
const { CartsModel } = require("../schema/index");
const { mongoose, ObjectId } = require("mongoose");

// Function to validate request body
const validateRequestBody = (req) => {
  const { productId, quantity } = req.body;

  if (!productId || !quantity) {
    throw new Error("Product ID and quantity are required");
  }

  return { productId, quantity };
};

// Function to find or create a cart
const findOrCreateCart = async (customerId) => {
  let cart = await CartsModel.findOne({ customerId });

  if (!cart) {
    cart = new CartsModel({
      customerId,
      cartItems: [],
    });
  }

  return cart;
};

// Function to add or update cart item
const addOrUpdateCartItem = (cart, productId, quantity) => {
  let existingCartItemIndex = -1;

  // Find the index of the cartItem with the productId
  existingCartItemIndex = getCartItemIndex(cart, productId);

  // If there is an existing cartItem with the productId
  if (existingCartItemIndex !== -1) {
    // Add the quantity
    cart.cartItems[existingCartItemIndex].quantity += quantity;

    // If the new quantity is zero or negative, remove it from the cartItems
    if (cart.cartItems[existingCartItemIndex].quantity <= 0) {
      cart.cartItems.splice(existingCartItemIndex, 1);
    }
  } else if (quantity > 0) {
    // Add the new productId only when the quantity is greater than zero
    cart.cartItems.push({ productId: productId, quantity });
  }
};

function getCartItemIndex(cart, productId) {
  const productIdObj = new mongoose.Types.ObjectId(productId); // Convert string to ObjectId
  for (let i = 0; i < cart.cartItems.length; i++) {
    // Convert item.productId to string for comparison
    if (cart.cartItems[i].productId.toString() === productIdObj.toString()) {
      return i;
    }
  }
  return -1;
}

// POST /cart/items
function putCartItems(server) {
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

/**
 * PUT /cart/items
 * Adds or updates the cart items.
 * Scenarios:
 *    - WHEN productId does not exist in the cart THEN productId is added into the cartItems array
 *    - WHEN productId exists in the cart and quantity is a positive integer THEN quantity is added to the productId item
 *    - WHEN productId exists in the cart and quantity is a negative integer THEN quantity is subtracted to the productId item
 *    - WHEN productId exists in the cart and quantity is a negative integer and subtracting results in 0 or less THEN productId is removed from cart
 * @param {*} server
 */
function putCartItems(server) {
  server.put("/cart/items", verifyToken, async (req, res) => {
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
// Function to delete cart item by productId
const deleteCartItemByProductId = async (customerId, productId) => {
  const cart = await CartsModel.findOne({ customerId });

  if (!cart) {
    throw new Error("Cart not found");
  }
  const productIdObj = new mongoose.Types.ObjectId(productId); // Convert string to ObjectId
  const updatedCartItems = [];
  for (let i = 0; i < cart.cartItems.length; i++) {
    if (cart.cartItems[i].productId.toString() != productIdObj.toString()) {
      updatedCartItems.push(cart.cartItems[i]);
    }
  }

  cart.cartItems = updatedCartItems;
  await cart.save();
};

// DELETE /cart/items/:productId
function deleteCartItemsProduct(server) {
  server.delete("/cart/items/:productId", verifyToken, async (req, res) => {
    try {
      const customerId = req.userId;
      const { productId } = req.params;
      await deleteCartItemByProductId(customerId, productId);

      res.status(204).send();
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Internal Server Error" });
    }
  });
}

// Function to retrieve cart items by customerId
const getCartItemsByCustomerId = async (customerId) => {
  const cart = await findOrCreateCart(customerId);
  return cart.cartItems;
};

// GET /cart/items
function getCartItems(server) {
  server.get("/cart/items", verifyToken, async (req, res) => {
    try {
      const customerId = req.userId;
      const cartItems = await getCartItemsByCustomerId(customerId);
      res.status(200).json(cartItems);
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
    putCartItems(server);
    deleteCartItems(server);
    deleteCartItemsProduct(server);
    getCartItems(server);
  }
}

module.exports = OrderManagementController;
