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

const createOrder = async (
  customerId,
  cartItems,
  paymentMethod,
  cardNumber,
  deliveryMethod,
  courier
) => {
  const order = new OrderModel({
    customerId,
    cartItems: cartItems.map((item) => ({
      productId: item.productId,
      quantity: item.quantity,
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

// Helper function to mask credit card numbers in orders
function maskCreditNumbersInOrders(orders) {
  for (const order of orders) {
    order.payment.cardNumber = maskCreditNumber(order.payment.cardNumber);
  }

  return orders;
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

const OrderService = {
  createOrder: createOrder,
  getAllOrders: getAllOrders,
  updateOrder: updateOrder,
};

module.exports = { OrderService };
