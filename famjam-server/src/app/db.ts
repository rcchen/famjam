import * as mongoose from "mongoose";

const mongoUri = process.env.MONGODB_URI;

mongoose.connect(mongoUri);

export const db = mongoose.connection;
