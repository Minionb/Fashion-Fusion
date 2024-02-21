const { verifyToken } = require("../util/verifyToken");
const { OrderService } = require("../services/OrderService");
const { CartsModel, FavoritesModel } = require("../schema/index");
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

/**
 * PUT /cart/items
 * Adds or updates the cart items.
 * Scenarios:
 *    - WHEN productId does not exist in the cart and quantity is a positive integer THEN productId is added to the cartItems array
 *    - WHEN productId does not exist in the cart and quantity is a negative integer THEN there are no changes to the cartItems array
 *    - WHEN productId exists in the cart and quantity is a positive integer THEN quantity is added to the productId item
 *    - WHEN productId exists in the cart and quantity is a negative integer THEN quantity is subtracted to the productId item
 *    - WHEN productId exists in the cart AND quantity is a negative integer
 *          AND subtracting it from existing quantity results in 0 or less
 *        THEN productId is removed from cart
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

const clearCart = async (customerId) => {
  const cart = await CartsModel.findOne({ customerId });

  if (cart) {
    cart.cartItems = [];
    await cart.save();
  }
};

// DELETE /cart/items
function deleteCartItems(server) {
  server.delete("/cart/items", verifyToken, async (req, res) => {
    try {
      const customerId = req.userId;
      const cart = await CartsModel.findOne({ customerId });

      clearCart(customerId);

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

// POST /cart/checkout
function checkoutCart(server) {
  server.post("/cart/checkout", verifyToken, async (req, res) => {
    try {
      const customerId = req.userId;
      const cart = await CartsModel.findOne({ customerId });

      if (!cart) {
        return res.status(404).json({ message: "Cart not found" });
      }
      // Check if cartItems is empty
      if (cart.cartItems.length === 0) {
        return res
          .status(400)
          .json({ message: "Cart is empty. Cannot proceed with checkout." });
      }

      // Assuming delivery method and courier are provided in the request body
      const paymentMethod = req.body.paymentMethod;
      const deliveryMethod = req.body.deliveryMethod;
      const courier = req.body.courier;
      const cardNumber = req.body.cardNumber;

      const order = await OrderService.createOrder(
        customerId,
        cart.cartItems,
        paymentMethod,
        cardNumber,
        deliveryMethod,
        courier
      );

      await clearCart(customerId);

      res.status(201).json({ message: "Order created successfully", order });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Internal Server Error" });
    }
  });
}

// GET /orders
function getOrders(server) {
  server.get("/orders", verifyToken, async (req, res) => {
    try {
      const customerId = req.userId;
      const orders = await OrderService.getAllOrders(customerId);
      res.status(200).json(orders);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Internal Server Error" });
    }
  });
} // Helper function to construct update fields
function constructUpdateFields(orderStatus, paymentStatus, deliveryStatus) {
  const updateFields = {};
  if (orderStatus) updateFields["status"] = orderStatus;
  if (paymentStatus) updateFields["payment.status"] = paymentStatus;
  if (deliveryStatus) updateFields["delivery.status"] = deliveryStatus;
  return updateFields;
}

// PATCH /orders/:orderId
function patchOrder(server) {
  server.patch("/orders/:orderId", verifyToken, async (req, res) => {
    try {
      const orderId = req.params.orderId;
      const { orderStatus, paymentStatus, deliveryStatus } = req.body;

      const updateFields = constructUpdateFields(
        orderStatus,
        paymentStatus,
        deliveryStatus
      );
      const updatedOrder = await OrderService.updateOrder(
        orderId,
        updateFields
      );

      if (!updatedOrder)
        return res.status(404).json({ message: "Order not found" });

      res
        .status(200)
        .json({ message: "Order updated successfully", order: updatedOrder });
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
    checkoutCart(server);

    getOrders(server);
    patchOrder(server);
  }
}

module.exports = OrderManagementController;
