
const mongoose = require ("mongoose");
const username = "fashion_fusion_db_admin";
const password = "33r2DsHiw94xPJwx";
const dbname = "fashion_fusion";

// Atlas MongoDb connection string format
let mongodbUriString = 'mongodb+srv://'+username+':'+password+'@cluster0.w4uxyix.mongodb.net/'+dbname+
'?retryWrites=true&w=majority';

const connectDB  = async () => {
      try {
        console.log(mongodbUriString)
        await mongoose.connect(mongodbUriString, { useNewUrlParser: true });
        console.log("Connected to the database");
      } catch (error) {
        console.error("Database connection error:", error);
      }
    }
    connectDB()

const productModel = require('./productSchema');
const productImageModel = require('./productImageSchema');



const product = new productModel
({
    product_name: 'Sample Product',
    category: 'Sample Category',
    product_description: 'Sample Description',
    price: 9.99,
    Tags: 'Sample Tag',
    sold_quantity: 0,
    inventory: [
      {
        size: 'S',
        quantity: 10
      },
      {
        size: 'M',
        quantity: 20
      }
    ]
  });

  // Save the product document
  product.save()


const fs = require('fs');
// Read the image file as a Buffer
const imageBuffer = fs.readFileSync('sample-image.jpg');

// Create a new product image document
const productImage = new productImageModel({
  product_id: '65ce9f9294d363ff1aff82e9', // The product ID to associate the image with
  filename: 'sample-image.jpg',
  contentType: 'image/jpeg',
  data: imageBuffer
});

// Save the product image document
productImage.save()