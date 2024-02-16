const { verifyToken } = require("../util/verifyToken");
const { ProductsModel } = require("../schema/index");

/**
 * Create product
 * @param {server} server
 */
function postProducts(server) {
  server.post("/products", verifyToken, async (req, res) => {
    try {
      if (req.userType !== "admin") {
        res.send(401, { message: "Unauthorized" });
      }
      const newProduct = new ProductsModel(req.body);
      // Save the new admin to the database
      await newProduct.save();
      res.send(201, { message: "Product added successfully" });
    } catch (error) {
      console.error("Product insertion error:", error);
      res.send(500, { message: "Internal server error" });
    }
  });
}

/**
 * Get all products
 * @param {server} server
 */
function getProducts(server) {
  server.get("/products", verifyToken, function (req, res, next) {
    // Query the database to retrieve all products
    ProductsModel.find({})
      .sort({ createdAt: "desc" })
      .then((products) => {
        // Return all of the products in the system
        res.send(products);
        return next();
      })
      .catch((error) => {
        return next(new Error(JSON.stringify(error.errors)));
      });
  });
}
/**
 * Get product by id
 */
function getProductsById(server) {
  server.get("/products/:id", verifyToken, async (req, res) => {
    try {
      const productId = req.params.id;

      // Fetch the product from the database by ID
      const product = await ProductsModel.findById(productId);

      if (!product) {
        return res.status(404).json({ error: "Product not found" });
      }

      res.json(product);
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  });
}

/**
 * Update product by id
 * @param {server} server
 */
function putProduct(server) {
  server.put("/products/:id", verifyToken, async (req, res) => {
    try {
      const productId = req.params.id;
      const updateData = req.body;

      // Find the product by ID, update it with the provided data, and return the modified document
      const updatedProduct = await ProductsModel.findByIdAndUpdate(
        productId,
        updateData,
        { new: true }
      );

      if (!updatedProduct) {
        return res.status(404).json({ error: "Product not found" });
      }

      res.json(updatedProduct);
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  });
}

/**
 * Delete product by id
 * @param {server} server
 */
function deleteProduct(server) {
  server.delete("/products/:id", verifyToken, async (req, res) => {
    try {
      if (req.userType !== "admin") {
        res.send(401, { message: "Unauthorized" });
      }

      const productId = req.params.id;

      // Find the product by ID and delete it
      const deletedProduct = await ProductsModel.findByIdAndDelete(productId);

      if (!deletedProduct) {
        return res.status(404).json({ error: "Product not found" });
      }

      res.json({ message: "Product deleted successfully" });
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
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
