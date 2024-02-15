
const mongoose = require ("mongoose");
const username = "fashion_fusion_db_admin";
const password = "33r2DsHiw94xPJwx";
const dbname = "fashion_fusion";

// Atlas MongoDb connection string format
let mongodbUriString = 'mongodb+srv://'+username+':'+password+'@cluster0.w4uxyix.mongodb.net/'+dbname+
'?retryWrites=true&w=majority';

const dbConfig = {
    connectDB: async () => {
      try {
        console.log(mongodbUriString)
        await mongoose.connect(mongodbUriString, { useNewUrlParser: true });
        console.log("Connected to the database");
      } catch (error) {
        console.error("Database connection error:", error);
      }
    },
}


module.exports = dbConfig;