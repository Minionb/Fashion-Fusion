const { verifyToken } = require("../util/verifyToken");

/**
 * Create product
 * @param {server} server
 */
function postProducts(server) {
  server.post("/products", verifyToken, function (req, res, next) {
    // TODO add logic
    res.send(501, { message: "Pending implementation" });
  });
}

/**
 * Get all products
 * @param {server} server
 */
function getProducts(server) {
  server.get("/products", verifyToken, function (req, res, next) {
    // TODO add logic
    res.send(501, { message: "Pending implementation" });
  });
}
/**
 * Get product by id
 */
function getProductsById(server) {
  server.get("/products/:id", verifyToken, function (req, res, next) {
    // TODO add logic
    res.send(501, { message: "Pending implementation" });
  });
}

/**
 * Update product by id
 * @param {server} server
 */
function putProduct(server) {
  server.put("/products/:id", verifyToken, function (req, res, next) {
    // TODO add logic
    res.send(501, { message: "Pending implementation" });
  });
}

/**
 * Delete product by id
 * @param {server} server
 */
function deleteProduct(server) {
  server.delete("/products/:id", verifyToken, function (req, res, next) {
    // TODO add logic for details
    res.send(501, { message: "Pending implementation" });
  });
}

/**
 * Get all Product Category
 * @param {server} server
 */
function getProductCategory(server) {
  server.get("/category", verifyToken, function (req, res, next) {
    // TODO add logic for details
    res.send(501, { message: "Pending implementation" });
  });
}
/**
 * Get Product Category by Id
 * @param {server} server
 */
function getProductCategoryById(server) {
  server.get("/category/:id", verifyToken, function (req, res, next) {
    // TODO add logic
    res.send(501, { message: "Pending implementation" });
  });
}

/**
 * Create Product Category
 * @param {server} server
 */
function postProductCategory(server) {
  server.post("/category", verifyToken, function (req, res, next) {
    // TODO add logic for creating category
    res.send(501, { message: "Pending implementation" });
  });
}

/**
 * Update Product Category by id
 * @param {server} server
 */
function putProductCategory(server) {
  server.put("/category/:id", verifyToken, function (req, res, next) {
    // TODO add logic for updating product category
    res.send(501, { message: "Pending implementation" });
  });
}
/**
 * Deletes Product Category by id
 * @param {server} server
 */
function deleteProductCategory(server) {
  server.delete("/category/:id", verifyToken, function (req, res, next) {
    // TODO add logic for deletiong product category
    res.send(501, { message: "Pending implementation" });
  });
}

class ProductManagementController {
  
  /**
   * Initializes the apis
   * @param {server} server
   */
  initApis(server) {
    postProducts(server);
    getProducts(server);
    getProductsById(server);
    putProduct(server);
    deleteProduct(server);

    postProductCategory(server);
    getProductCategory(server);
    getProductCategoryById(server);
    putProductCategory(server);
    deleteProductCategory(server);
  }
}

module.exports = ProductManagementController;
