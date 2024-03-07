const { ProductsModel } = require("../schema");
const OrderModel = require("../schema/orderSchema");
const { maskCreditNumber } = require("../util/cardUtils");

const OrderStatus = {
  pending: "pending",
  processing: "processing",
  packed: "packed",
  shipped: "shipped",
  delivered: "delivered",
};

const PaymentStatus = {
  pending: "pending",
  processing: "processing",
  failed: "failed",
  paid: "paid",
};

const DeliveryMethod = {
  pickup: "pickup",
  standard_delivery: "standard_delivery",
  express_delivery: "express_delivery",
};

const DeliveryCourier = {
  pickup: "pickup",
  DHL: "DHL",
  UPS: "UPS",
};

const DeliveryStatus = {
  pending: "pending",
  available_for_pickup: "available_for_pickup",
  shipped: "shipped",
  in_transit: "in_transit",
  out_for_delivery: "out_for_delivery",
  delivered: "delivered",
};

function getProductPrice(cartProducts, productId) {
  const product = cartProducts.find(
    (item) => item._id.toString() === productId.toString()
  );
  return product ? product.price : null; // Return the price if product is found, otherwise return null
}

function getProduct(cartProducts, productId) {
  const product = cartProducts.find(
    (item) => item._id.toString() === productId.toString()
  );
  return product;
}

const createOrder = async (
  customerId,
  cartItems,
  paymentMethod,
  cardNumber,
  deliveryMethod,
  courier
) => {
  const productIds = cartItems.map((cartItem) => cartItem.productId);
  const cartProducts = await ProductsModel.find({
    _id: { $in: productIds },
  });

  updateProduct(cartItems);

  const order = new OrderModel({
    customerId,
    cartItems: cartItems.map((item) => ({
      productId: item.productId,
      quantity: item.quantity,
      price: getProductPrice(cartProducts, item.productId),
    })),
    status: OrderStatus.pending, // Set order status to pending
    payment: {
      method: paymentMethod,
      cardNumber: cardNumber,
      status: PaymentStatus.pending, // Set payment status to pending
    },
    delivery: {
      method: deliveryMethod,
      courier: courier,
      status: DeliveryStatus.pending, // Assuming initial delivery status is pending
    },
  });

  await order.save();

  return order;
};

async function updateProduct(cartItems) {
  cartItems.forEach(async (cartItem) => {
    const product = await ProductsModel.findById(cartItem.productId);
    if (product.inventory.length > 0) {
      var defaultInventory = product.inventory[0];
      if (defaultInventory.quantity >= cartItem.quantity) {
        defaultInventory.quantity -= cartItem.quantity;
        product.sold_quantity += cartItem.quantity;
      }
    }
    product.save();
  });
}

// Helper function to mask credit card numbers in orders
function maskCreditNumbersInOrders(orders) {
  for (const order of orders) {
    order.payment.cardNumber = maskCreditNumber(order.payment.cardNumber);
  }

  return orders;
}
// Helper function to mask credit card numbers in orders
function maskCreditNumbersInOrder(order) {
  order.payment.cardNumber = maskCreditNumber(order.payment.cardNumber);
  return order;
}

async function getAllOrders(customerId) {
  const orders = await OrderModel.find({ customerId });
  const maskedOrders = maskCreditNumbersInOrders(orders);
  return maskedOrders;
}
// Helper function to update order
async function updateOrder(orderId, updateFields) {
  return await OrderModel.findByIdAndUpdate(
    { _id: orderId },
    { $set: updateFields },
    { new: true }
  );
}

async function getOrderById(orderId) {
  const order = await OrderModel.findById(orderId);
  if (!order) return order;

  const cartItems = order.cartItems;
  const productIds = cartItems.map((cartItem) => cartItem.productId);
  const cartProducts = await ProductsModel.find({
    _id: { $in: productIds },
  });
  // Construct a separate response object for the order
  const responseOrder = {
    orderId: order._id,
    customerId: order.customerId,
    cartItems: order.cartItems,
    status: order.status,
    totalAmount: order.totalAmount,
    payment: order.payment,
    delivery: order.delivery,
    createdAt: order.createdAt,
    updatedAt: order.updatedAt,
    // Add any other properties you want to include in the response
  };

  const maskedOrders = maskCreditNumbersInOrder(responseOrder);

  const responseCartItems = cartItems.map((cartItem) => {
    const product = OrderService.getProduct(cartProducts, cartItem.productId);
    return {
      productId: cartItem.productId,
      quantity: cartItem.quantity,
      price: product ? product.price : null,
      productName: product ? product.product_name : null,
    };
  });
  maskedOrders.cartItems = responseCartItems;
  return maskedOrders;
}

const OrderService = {
  createOrder: createOrder,
  getAllOrders: getAllOrders,
  getOrderById: getOrderById,
  updateOrder: updateOrder,
  getProductPrice: getProductPrice,
  getProduct: getProduct,
};

module.exports = { OrderService };
