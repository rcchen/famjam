import * as mongoose from "mongoose";

const mongoUri = (process.env.MONGODB_URI || "mongodb://localhost/test");

mongoose.connect(mongoUri);

export const db = mongoose.connection;
