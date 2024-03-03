const { verifyToken } = require("../util/verifyToken");
const { OrderService } = require("../services/OrderService");
const {
  CartsModel,
  FavoritesModel,
  ProductsModel,
  OrdersModel,
} = require("../schema/index");
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
const addOrUpdateCartItem = (cart, product, quantity) => {
  const productId = product._id;
  let existingCartItemIndex = -1;

  // Find the index of the cartItem with the productId
  existingCartItemIndex = getCartItemIndex(cart, productId);

  // If there is an existing cartItem with the productId
  if (existingCartItemIndex !== -1) {
    // Add the quantity
    cart.cartItems[existingCartItemIndex].quantity += quantity;
    cart.cartItems[existingCartItemIndex].price = product.price;

    // If the new quantity is zero or negative, remove it from the cartItems
    if (cart.cartItems[existingCartItemIndex].quantity <= 0) {
      cart.cartItems.splice(existingCartItemIndex, 1);
    }
  } else if (quantity > 0) {
    // Add the new productId only when the quantity is greater than zero
    cart.cartItems.push({
      productId: productId,
      quantity,
    });
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
  server.put("/cart/items", async (req, res) => {
    await verifyToken(req, res);
    try {
      const customerId = req.userId;
      const { productId, quantity } = validateRequestBody(req);
      let cart = await findOrCreateCart(customerId, productId, quantity);
      cart.customerId = customerId;

      const product = await ProductsModel.findById(productId);
      if (!product)
        return res.status(404).json({ message: "Product not found" });

      addOrUpdateCartItem(cart, product, quantity);
      await cart.save();

      const productIds = cart.cartItems.map((cartItem) => cartItem.productId);
      const cartProducts = await ProductsModel.find({
        _id: { $in: productIds },
      });
      return res
        .status(201)
        .send(mapToCartResponse(cart.cartItems, cartProducts));
    } catch (error) {
      console.error(error);
      return res.status(400).json({ message: error.message });
    }
  });
}

const clearCart = async (customerId, cartItems = null) => {
  const cart = await CartsModel.findOne({ customerId });

  if (cartItems !== null && cartItems.length > 0) {
    // Extract productId values from cartItems parameter
    const cartItemProductIds = cartItems.map((item) => item.productId);
    cartItemProductIds.forEach((element) => {
      // Filter out items that are not in cartItemProductIds
      var existingCartItemIndex = getCartItemIndex(cart, element);
      if (existingCartItemIndex > -1) {
        cart.cartItems.splice(existingCartItemIndex, 1);
      }
    });
  } else {
    // If cartItems is null or empty, clear the entire cart
    cart.cartItems = [];
  }
  await cart.save();
};

// DELETE /cart/items
function deleteCartItems(server) {
  server.delete("/cart/items", async (req, res) => {
    await verifyToken(req, res);
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
  server.delete("/cart/items/:productId", async (req, res) => {
    await verifyToken(req, res);
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
async function getCartItems(server) {
  server.get("/cart/items", async (req, res) => {
    await verifyToken(req, res);
    try {
      const customerId = req.userId;
      const cartItems = await getCartItemsByCustomerId(customerId);

      const productIds = cartItems.map((cartItem) => cartItem.productId);
      const cartProducts = await ProductsModel.find({
        _id: { $in: productIds },
      });

      // Construct separate response objects for cart items with prices
      const cartReponse = mapToCartResponse(cartItems, cartProducts);
      return res.status(200).json(cartReponse);
    } catch (error) {
      console.error(error);
      return res.status(500).json({ message: "Internal Server Error" });
    }
  });
}

function mapToCartResponse(cartItems, cartProducts) {
  return cartItems.map((cartItem) => {
    const product = OrderService.getProduct(cartProducts, cartItem.productId);
    return mapToCartItemResponse(cartItem, product);
  });
}

function mapToCartItemResponse(cartItem, product) {
  return {
    productId: cartItem.productId,
    quantity: cartItem.quantity,
    price: product ? product.price : null,
    productName: product ? product.product_name : null,
    imageId: product
      ? product.images.length > 0
        ? product.images[0]
        : ""
      : "",
  };
}

// POST /cart/checkout
function checkoutCart(server) {
  server.post("/cart/checkout", async (req, res) => {
    await verifyToken(req, res);
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
// POST /checkout
function checkout(server) {
  server.post("/checkout", async (req, res) => {
    await verifyToken(req, res);
    try {
      const customerId = req.userId;

      // Assuming delivery method and courier are provided in the request body
      const paymentMethod = req.body.paymentMethod;
      const deliveryMethod = req.body.deliveryMethod;
      const courier = req.body.courier;
      const cardNumber = req.body.cardNumber;
      const cartItems = req.body.cartItems;
      // Check if cartItems is empty
      if (cartItems.length === 0) {
        return res
          .status(400)
          .json({ message: "Cart is empty. Cannot proceed with checkout." });
      }

      const order = await OrderService.createOrder(
        customerId,
        cartItems,
        paymentMethod,
        cardNumber,
        deliveryMethod,
        courier
      );

      await clearCart(customerId, cartItems);

      res.status(201).json({ message: "Order created successfully", order });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Internal Server Error" });
    }
  });
}

// GET /orders
async function getOrders(server) {
  server.get("/orders", async (req, res) => {
    await verifyToken(req, res);
    try {
      const customerId = req.userId;
      const orders = await OrderService.getAllOrders(customerId);

      // Construct separate response objects for orders
      const responseOrders = orders.map((order) => {
        return {
          orderId: order._id,
          status: order.status,
          totalAmount: order.totalAmount,
          paymentMethod: order.payment.method,
          deliveryMethod: order.delivery.method,
          createdAt: order.createdAt,
          updatedAt: order.updatedAt,
        };
      });

      return res.status(200).json(responseOrders);
    } catch (error) {
      console.error(error);
      return res.status(500).json({ message: "Internal Server Error" });
    }
  });
}

// GET /order/:id
async function getOrderById(server) {
  server.get("/orders/:id", async (req, res) => {
    try {
      const orderId = req.params.id;

      // Find the order by its ID
      const order = await OrderService.getOrderById(orderId);

      // If order is not found, return 404
      if (!order) {
        return res.status(404).json({ message: "Order not found" });
      }

      // Return the separate response object with the order details
      return res.status(200).json(order);
    } catch (error) {
      console.error(error);
      return res.status(500).json({ message: "Internal Server Error" });
    }
  });
}

// Helper function to construct update fields
function constructUpdateFields(orderStatus, payment, delivery) {
  const updateFields = {};
  if (orderStatus) updateFields["status"] = orderStatus;
  // If payment or delivery details are provided in the request body, update them
  if (payment) updateFields["payment"] = payment;
  if (delivery) updateFields["delivery"] = delivery;
  return updateFields;
}
// PATCH /orders/:orderId
async function patchOrder(server) {
  server.patch("/orders/:orderId", async (req, res) => {
    await verifyToken(req, res);
    try {
      const orderId = req.params.orderId;
      const { orderStatus, payment, delivery } = req.body;

      const updateFields = constructUpdateFields(
        orderStatus,
        payment,
        delivery
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

async function getOrDefaultFavorites(customerId) {
  let favorite = await FavoritesModel.findOne({ customerId: customerId });

  if (!favorite) {
    favorite = new FavoritesModel({ customerId, favoriteItems: [] });
  }
  return favorite;
}

// PUT /favorites/item endpoint handler
const addFavoriteItem = async (req, res) => {
  await verifyToken(req, res);
  const customerId = req.userId;
  const { productId } = req.body;
  if (productId == null)
    res.status(400).json({ error: "Bad request. productId is required" });

  try {
    const productIdObj = new mongoose.Types.ObjectId(productId);
    const favorite = await getOrDefaultFavorites(customerId);

    if (
      !favorite.favoriteItems.some(
        (item) => item.toString() === productIdObj.toString()
      )
    ) {
      favorite.favoriteItems.push(productId);
      await favorite.save();
    }

    res.status(201).json({ message: "Item added to favorites successfully" });
  } catch (error) {
    console.error("Error adding item to favorites:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

// DELETE /favorites/item endpoint handler
const removeFavoriteItem = async (req, res) => {
  await verifyToken(req, res);
  const customerId = req.userId;
  const { productId } = req.body;

  try {
    const productIdObj = new mongoose.Types.ObjectId(productId);
    const favorite = await getOrDefaultFavorites(customerId);
    favorite.favoriteItems = favorite.favoriteItems.filter(
      (item) => item.toString() !== productIdObj.toString()
    );
    await favorite.save();

    res.json({ message: "Item removed from favorites successfully" });
  } catch (error) {
    console.error("Error removing item from favorites:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

// GET /favorites/item endpoint handler
const getFavoriteItems = async (req, res) => {
  await verifyToken(req, res);
  const customerId = req.userId;
  try {
    const favorite = await getOrDefaultFavorites(customerId);
    const favoriteProductIds = favorite.favoriteItems;
    if (!favoriteProductIds || favoriteProductIds.length == 0)
      return res.status(200).json(favoriteProductIds);
    const faveProducts = await ProductsModel.find({
      _id: { $in: favoriteProductIds },
    });

    // Construct separate response objects for cart items with prices
    const responseItems = favoriteProductIds.map((productId) => {
      const product = OrderService.getProduct(faveProducts, productId);
      const imageId = product
        ? product.images.length > 0
          ? product.images[0]
          : ""
        : "";
      return {
        productId: productId,
        price: product ? product.price : null,
        productName: product ? product.product_name : null,
        imageId: imageId,
      };
    });

    return res.status(200).json(responseItems);
  } catch (error) {
    console.error("Error fetching favorite items:", error);
    return res.status(500).json({ error: "Internal server error" });
  }
};

// Enclose each endpoint handler in a function that accepts a server
const attachFavoritesRoutes = (server) => {
  server.put("/favorite/items", addFavoriteItem);
  server.delete("/favorite/items", removeFavoriteItem);
  server.get("/favorite/items", getFavoriteItems);
};

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
    // checkoutCart(server);
    checkout(server);

    getOrders(server);
    getOrderById(server);
    patchOrder(server);

    attachFavoritesRoutes(server);
  }
}

module.exports = OrderManagementController;
