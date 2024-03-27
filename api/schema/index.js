const AdminsModel = require("./adminSchema");
const ResetPasswordModel = require("./resetPasswordSchema");
const ProductsModel = require("./productSchema");
const ProductImagesModel = require("./productImageSchema");
const CartsModel = require("./cartSchema");
const OrdersModel = require("./orderSchema");
const FavoritesModel = require("./favoriteSchema");
const { CustomersModel, paymentSchema, addressSchema } = require("./customerSchema");

module.exports = {
  CustomersModel,
  AdminsModel,
  ResetPasswordModel,
  ProductsModel,
  ProductImagesModel,
  CartsModel,
  OrdersModel,
  FavoritesModel,
  paymentSchema,
  addressSchema,
};
