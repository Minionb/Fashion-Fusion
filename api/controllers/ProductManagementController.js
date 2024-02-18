const { verifyToken, verifyAdminToken } = require("../util/verifyToken");
const { ProductsModel, ProductImagesModel } = require("../schema/index");
const multer = require("multer");

/**
 * Create product
 * @param {server} server
 */
function postProducts(server) {
  server.post("/products", verifyAdminToken, async (req, res) => {
    try {
      const newProduct = new ProductsModel(req.body);
      newProduct.createdBy = req.userId;
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
  server.get("/products", verifyToken, async (req, res, next) => {
    try {
      const filter = buildFilter(req.query);
      const sortOption = buildSortOption(req.query.sort);
      const products = await ProductsModel.find(filter).sort(sortOption);
      res.send(products);
    } catch (error) {
      console.error(error);
      return next(new Error(JSON.stringify(error.errors)));
    }
  });
}

function buildFilter(query) {
  const filter = {};
  if (query.productName)
    filter.product_name = new RegExp(query.productName, "i");
  if (query.description)
    filter.product_description = new RegExp(query.description, "i");
  if (query.tags) filter.tags = new RegExp(query.tags, "i");
  if (query.category) filter.category = query.category;
  if (query.price) {
    const priceRange = query.price.split("-");
    if (priceRange.length === 1) {
      filter.price = priceRange[0];
    } else if (priceRange.length === 2) {
      filter.price = { $gte: priceRange[0], $lte: priceRange[1] };
    }
  }
  if (query.size) filter["inventory.size"] = query.size;
  return filter;
}

function buildSortOption(sort) {
  let sortOption = {};
  if (sort) {
    switch (sort) {
      case "price_low_to_high":
        sortOption = { price: 1 };
        break;
      case "price_high_to_low":
        sortOption = { price: -1 };
        break;
      default:
        sortOption = { [sort]: -1 }; // Assuming sort is a valid field for sorting
        break;
    }
  } else {
    // Default sorting when no sort parameter is provided
    sortOption = { updatedAt: -1, createdAt: -1 };
  }
  return sortOption;
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
  server.delete("/products/:id", verifyAdminToken, async (req, res) => {
    try {
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

// Multer storage configuration
const storage = multer.memoryStorage(); // Store files in memory as Buffer
// Multer upload instance
const upload = multer({ storage: storage });

function postProductImages(server) {
  // Route to handle image upload
  server.post(
    "/products/:id/images",
    verifyToken,
    upload.single("image"),
    async (req, res) => {
      try {
        const productId = req.params.id;
        const product = await ProductsModel.findById(productId);

        if (!product) {
          return res.status(404).json({ error: "Product not found" });
        }

        // Read the uploaded image file
        const imageData = req.file.buffer;
        const contentType = req.file.mimetype;
        const filename = req.file.originalname;

        // Create a new image document
        const newImage = new ProductImagesModel({
          product_id: productId,
          data: imageData,
          contentType: contentType,
          filename: filename,
        });

        // Save the image to the database
        await newImage.save();

        // Update the product to include the new image
        product.images.push(newImage._id);
        await product.save();

        res
          .status(201)
          .json({ message: "Image uploaded successfully", image: newImage });
      } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Internal server error" });
      }
    }
  );
}

/**
 * Get product images using productImageId
 * @param {server} server
 */
function getProductImages(server) {
  // GET /products/images/:id
  server.get("/products/images/:id", verifyToken, async (req, res) => {
    try {
      const productImageId = req.params.id;

      // Find the product by ID and populate the 'images' field
      const productImage = await ProductImagesModel.findById(productImageId);
      if (!productImage) {
        return res.status(404).json({ error: "Product not found" });
      }

      // Set content type as image/jpeg for demonstration purpose
      res.set("Content-Type", productImage.contentType);

      // Send the image data as response
      res.status(200).send(productImage.data);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: "Internal server error" });
    }
  });
}

/**
 * Delete product image by id
 * @param {server} server
 */
function deleteProductImage(server) {
  server.delete("/products/images/:id", verifyAdminToken, async (req, res) => {
    try {
      const productImageId = req.params.id;

      // Find the product image by ID
      const productImage = await ProductImagesModel.findById(productImageId);
      if (!productImage) {
        return res.status(404).json({ error: "Product image not found" });
      }

      // Delete the product image
      await ProductImagesModel.findByIdAndDelete(productImageId);

      // Remove the ID of the deleted image from the ProductsModel.images array
      await ProductsModel.updateMany({}, { $pull: { images: productImageId } });

      res.status(200).json({ message: "Product image deleted successfully" });
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: "Internal server error" });
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

    postProductImages(server);
    getProductImages(server);
    deleteProductImage(server);

    postProductCategory(server);
    getProductCategory(server);
    getProductCategoryById(server);
    putProductCategory(server);
    deleteProductCategory(server);
  }
}

module.exports = ProductManagementController;
