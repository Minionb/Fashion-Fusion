const { ProductsModel } = require("../schema");
const OrderModel = require("../schema/orderSchema");
const { maskCreditNumber } = require("../util/cardUtils");
const { convertExpiryToDate } = require("../util/formattingUtils");

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

const createOrder = async (customerId, orderRequest) => {
  const productIds = orderRequest.cartItems.map(
    (cartItem) => cartItem.productId
  );
  const cartProducts = await ProductsModel.find({
    _id: { $in: productIds },
  });
  const normalizedOrder = normalizeOrderData(orderRequest);
  updateProduct(normalizedOrder.cartItems);

  const order = new OrderModel({
    customerId,
    cartItems: normalizedOrder.cartItems,
    status: OrderStatus.pending, // Set order status to pending
    payment: normalizedOrder.payment,
    address: normalizedOrder.address,
    delivery: normalizedOrder.delivery,
    subtotal: normalizedOrder.subtotal,
    tax: normalizedOrder.tax,
    totalAmount: normalizedOrder.totalAmount,
  });

  await order.save();
  
  return getOrderById(order._id.toString());
};

function normalizeOrderData(orderData) {
  if (orderData.payment) {
    orderData.payment.expirationDate = convertExpiryToDate(
      orderData.payment.expirationDate
    );
  }

  if (orderData.address && !orderData.address.country)
    orderData.address.country = "Canada";

  return orderData;
}

async function updateProduct(cartItems) {
  cartItems.forEach(async (cartItem) => {
    const product = await ProductsModel.findById(cartItem.productId);
    if (!product) {
      console.log(`Product id=${cartItem.productId} not found!`);
    } else if (product.inventory && product.inventory.length > 0) {
      var defaultInventory = product.inventory[0];
      if (defaultInventory.quantity >= cartItem.quantity) {
        defaultInventory.quantity -= cartItem.quantity;
        product.sold_quantity += cartItem.quantity;
      }

      product.save();
    }
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

async function getCustomerOrders(customerId, createDateSort, filter) {
  var orders = [];
  var createDateSortVal = createDateSort? createDateSort: -1
  if(customerId)
    orders = await OrderModel.find({ customerId }).sort({ createdAt: createDateSortVal });
  else {
    orders = await OrderModel.find(filter).sort({ createdAt: createDateSortVal });
  }

  const maskedOrders = maskCreditNumbersInOrders(orders);

  for (const order of maskedOrders) {
    var newCartItems = await getCartProducts(order.cartItems);
    order.cartItems = newCartItems;
  }

  return maskedOrders;
}

async function getCartProducts(cartItems) {
  const productIds = cartItems.map((cartItem) => cartItem.productId);
  const cartProducts = await ProductsModel.find({
    _id: { $in: productIds },
  });
  cartItems.forEach((cartItem) => {
    var product = getProduct(cartProducts, cartItem.productId);
    if (product) cartItem.productName = product.product_name;
  });
  return cartItems;
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

  const maskedOrders = maskCreditNumbersInOrder(order.toObject());
  const newCartItems = [];
  for (var cartItem of maskedOrders.cartItems) {
    const product = await OrderService.getProduct(cartProducts, cartItem.productId);
    if (product) {
      cartItem.productName = product.product_name;
      if (product.images && product.images.length > 0) {
        cartItem.imageId = product.images[0];
      }
    }
  }
  return maskedOrders;
}

const OrderService = {
  createOrder: createOrder,
  getAllOrders: getCustomerOrders,
  getOrderById: getOrderById,
  updateOrder: updateOrder,
  getProductPrice: getProductPrice,
  getProduct: getProduct,
};

module.exports = { OrderService };
