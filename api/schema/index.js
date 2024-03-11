const AdminsModel = require("./adminSchema");
const ResetTokensModel = require("./resetTokenSchema");
const ProductsModel = require("./productSchema");
const ProductImagesModel = require("./productImageSchema");
const CartsModel = require("./cartSchema");
const OrdersModel = require("./orderSchema");
const FavoritesModel = require("./favoriteSchema");
const { CustomersModel, paymentSchema, addressSchema } = require("./customerSchema");

module.exports = {
  CustomersModel,
  AdminsModel,
  ResetTokensModel,
  ProductsModel,
  ProductImagesModel,
  CartsModel,
  OrdersModel,
  FavoritesModel,
  paymentSchema,
  addressSchema,
};
