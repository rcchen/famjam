import * as mongoose from "mongoose";

const mongoUri = (process.env.NODE_ENV || "mongodb://localhost/test");

mongoose.connect(mongoUri);

export const db = mongoose.connection;
